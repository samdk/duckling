class User < ActiveRecord::Base
  include Filters
  
  is_soft_deleted
  
  include AuthorizedModel
  def permit_create?(*)
    true
  end
  
  def permit_read?(user, *)
    conds = '(user_id = ? AND other_user_id = ?) OR (user_id = ? AND other_user_id = ?)'
    Acquaintance.where(conds, id, user.id, user.id, id).exists?
  end
  
  def permit_update?(user, *)
    self == user
  end
  
  def permit_destroy?(user, *)
    self == user
  end
  
  
  attr_accessor :password_confirmation, :password_confirmation_changed
  
  THUMBS = {styles: {large: ['100x100#', :png], small: ['60x60#', :png]},
            default_url: '/images/avatars/default_:style_avatar.png',
            default_style: :small,
            url: '/people/:id/avatar_:style.png',
            path: ':rails_root/attachments/avatars/:style/:id.png'}.freeze
  has_attached_file :avatar, FILE_STORAGE_OPTS.merge(THUMBS)
  validates_length_of :avatar_file_name, maximum: 100
    
  serialize :phone_numbers, Hash
  serialize :email_addresses, Array
  serialize :unverified_email_addresses, Array
  
  def self.with_email(email, id_only = false)
    caching("email_#{email}", ids_only: id_only) {
      User.with_uncached_email(email).first
    }.try(:first)
  end
  
  # DANGER, slow
  scope :with_uncached_email, ->(email){
    where('email_addresses LIKE ?', "%- #{email}\n%")
  }
  
  # DANGER, slow
  scope :with_uncached_unverified_email, ->(email){
    where('unverified_email_addresses LIKE ?', "%- #{email}\n")
  }
  
  # DANGER, slow  
  scope :with_uncached_phone, ->(phone){
    where('phone_numbers LIKE ?', "%: #{PhoneFormatter.format(phone)}\n")
  }
  
  has_many :addresses
  belongs_to :primary_address, class_name: 'Address'
  
  has_many :deployments, as: :deployed
  has_many :activations, through: :deployments
  has_many :current_activations, through: :deployments, conditions: {active: true}
  has_many :past_activations, through: :deployments, conditions: {active: true}
  
  has_many :memberships
  has_many :organizations, through: :memberships
  
  def administrate(org)
    memberships.where(organization_id: org.id).delete_all
    memberships.create(organization: org, access_level: 'admin') 
  end
  
  def manage(org)
    memberships.where(organization_id: org.id).delete_all
    memberships.create(organization: org, access_level: 'manager')
  end
  
  def manages?(org_id)
    memberships.where("organization_id = ? AND access_level <> ''", org_id).exists?
  end
  
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
  
  validates_length_of :name_prefix, maximum: 50
  validates :first_name,    presence: true, length: {maximum: 50}
  validates :last_name,     presence: true, length: {maximum: 50}
  validates_length_of :name_suffix, maximum: 50
  
  validate :password_validations
  def password_validations  
    if (1..7).include? password.size
      errors.add(:password, t('user.password.too_short'))
    end
    
    if new_record?
      if password_confirmation.blank?
        errors.add(:password_confirmation, t('user.password.confirmation_required'))
      end
      
      if password.blank?
        errors.add(:password, t('user.password.required'))
      end
    end
    
    unless password_confirmation.blank? or @raw_password == password_confirmation
      errors.add(:password_confirmation, t('user.password.match_confirmation'))
    end
  end
  
  validate :email_validations
  def email_validations
    if email_addresses.blank?
      errors.add(:email_addresses, t('user.email.missing'))
    end
    
    dups = email_addresses.any? do |e|
      u = User.with_email(e, true)
      u && u != self.id
    end
    
    errors.add(:email_addresses, t('user.email.duplicate')) if dups
    
    email_addresses.select {|x| x !~ /\A[^@]+@[^@]+\.[^@]+\z/}.each_with_index do |addr, i|
      errors.add("email_address_#{i}".to_sym, t('user.email.bad_format'))
    end
    
  end
  
  before_save do |user|
    user.phone_numbers.each do |k, v|
      user.phone_numbers[k] = PhoneFormatter.format(v)
    end
    
    if user.email_addresses_changed?
      user.email_addresses.map!(&:downcase).each do |email|
        caching("email_#{email}", force: true) { user }
      end
    end
  end
  
  before_destroy do |user|
    user.email_addresses.each do |email|
      Rails.cache.delete("email_#{email}")
    end
  end

  after_save do |user|
    user.password_confirmation_changed = false
  end
  
  after_initialize do |user|
    user.phone_numbers   ||= {'Cell' => '', 'Desk' => ''}
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
    return false if new_pass.blank?
    @password = BCrypt::Password.create(new_pass)
    @raw_password = new_pass
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
    
  def can?(hash, args = {})
    hash.all? do |action, object|
      object.send "permit_#{action}?", self, args
    end
  end  
  
end
