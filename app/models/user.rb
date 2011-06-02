class User < ActiveRecord::Base  
  include Filters
  is_soft_deleted
  
  attr_accessor :password_confirmation, :password_confirmation_changed
  
  THUMBS = {styles: {large: ['100x100#', :png], small: ['60x60#', :png]},
            default_url: '/images/avatars/default_:style_avatar.png',
            default_style: :small,
            url: '/people/:id/avatar_:style.png',
            path: ':rails_root/attachments/avatars/:style/:id.png'}.freeze
  has_attached_file :avatar, FILE_STORAGE_OPTS.merge(THUMBS)
    
  serialize :phone_numbers, Hash
  serialize :email_addresses, Array
  
  # TODO: make this O(1) instead of O(n)
  scope :with_email, lambda { |email| 
    where('email_addresses LIKE ?', "%- #{email}\n%")
  }
  
  has_many :addresses
  has_one :primary_address, class_name: 'Address'
  
  has_many :activationships
  has_many :activations, through: :activationships  
  
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :administrated_organizations, class_name: 'Organization'
  has_and_belongs_to_many :managed_organizations, class_name: 'Organization'
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :sections, {
    join_table: 'groups_users',
    association_foreign_key: 'group_id'
  }
  
  ACQ_FINDER_SQL = <<-SQL
      SELECT * FROM users
      INNER JOIN acquaintances
        ON ((users.id = acquaintances.user_id AND acquaintances.other_user_id = \#{id})
        OR  (users.id = acquaintances.other_user_id AND acquaintances.user_id = \#{id}))
      WHERE (users.deleted_at IS NULL)
  SQL
  
  ACQ_DELETE_SQL = <<-SQL
    DELETE FROM acquaintances
    WHERE ((user_id = \#{id}) OR (other_user_id = \#{id}))
  SQL
  
  has_and_belongs_to_many :acquaintances, {
    class_name:              'User',
    association_foreign_key: 'other_user_id',
    join_table:              'acquaintances',
    finder_sql:              ACQ_FINDER_SQL,
    delete_sql:              ACQ_DELETE_SQL
  }
    
  validates :password_hash, presence: true
  validates :first_name,    presence: true
  validates :last_name,     presence: true
  
  validate :password_validations
  def password_validations
    return unless @password_confirmation_changed && password_hash_changed?
    if password_confirmation.blank? || password_confirmation.size < 7
      errors.add(:password, t('user.password.too_short'))
    end
    
    unless password == password_confirmation
      errors.add(:password_confirmation, t('user.password.match_confirmation'))
    end
  end
  
  validate :email_validations
  def email_validations
    if email_addresses.blank?
      errors.add(:email_addresses, t('user.email.missing'))
    end
    
    dups = email_addresses.any? do |e|
      u = User.with_email(e).first
      u && u.id != self.id
    end
    
    errors.add(:email_addresses, t('user.email.duplicate')) if dups
  end
  
  before_save do |user|
    user.phone_numbers.each do |k, v|
      user.phone_numbers[k] = PhoneFormatter.format(v)
    end
        
    user.email_addresses.map!(&:downcase)
  end

  after_save do |user|
    user.password_confirmation_changed = false
  end
  
  after_initialize do |user|
    user.phone_numbers   ||= {}
    user.email_addresses ||= []
  end

  def primary_email
    email_addresses.first
  end
  def primary_email=(email)
    (self.email_addresses ||= []) << email
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def password_confirmation=(pc)
    @password_confirmation_changed = true
    @password_confirmation = pc
  end
  
  def password
    @password ||= BCrypt::Password.new(password_hash)
  end
  
  def password=(new_pass)    
    @password = BCrypt::Password.create(new_pass)
    self.password_hash = @password
  end
  
  def password?(pass)
    password == pass
  end
  
  def notifications
    @notifications ||= NotificationService.new(self)
  end
  
  def self.with_credentials(email, pass)
    u = User.with_email(email).first
    u.try(:password?, pass) && u
  end
  
  def name
    [name_prefix,first_name,last_name,name_suffix].join(' ').strip.gsub(/\s+/, ' ')
  end
  
  def all_organizations
    organizations | managed_organizations | administrated_organizations
  end
  
  def all_organization_ids
    organization_ids | managed_organization_ids | administrated_organization_ids
  end
  
  def can_see_organization?(org)
    all_organizations.include?(org) or org.public?
  end
  
end
