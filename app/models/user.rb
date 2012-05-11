class User < ActiveRecord::Base
  include Filters
  
  def serializable_hash(opts)
    opts[:except] = Array.wrap(opts[:except]) + %w[
      api_token
      created_at deleted_at updated_at
      state
      cookie_token_expires_at cookie_token
      reset_token
      primary_address_id primary_email_id
      avatar_updated_at avatar_file_name
      password_hash
    ]

    super opts
  end
  
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
    false
  end

  attr_accessor :password_confirmation, :password_confirmation_changed
  
  attr_accessible :first_name, :last_name, :name_prefix, :name_suffix,
    :phone_numbers, :primary_address_id, :password, :password_confirmation
  
  THUMBS = {styles: {large: ['100x100#', :png], small: ['60x60#', :png]},
            default_url: '/assets/avatars/default_:style_avatar.png',
            default_style: :small,
            url: '/people/:id/avatar_:style.png',
            path: ':rails_root/attachments/avatars/:style/:id.png'}.freeze
  has_attached_file :avatar, FILE_STORAGE_OPTS.merge(THUMBS)
  validates_length_of :avatar_file_name, maximum: 100
    
  serialize :phone_numbers, Hash
  
  has_many :addresses
  belongs_to :primary_address, class_name: 'Address'
  
  # default_scope includes(:primary_email)
  
  has_many :deployments, as: :deployed
  has_many :activations, through: :deployments
  has_many :current_activations, through: :deployments, conditions: {active: true}
  has_many :past_activations, through: :deployments, conditions: {active: true}
  
  has_many :memberships
  has_many :organizations, through: :memberships
  belongs_to :primary_organization, class_name: 'Organization'
  
  has_and_belongs_to_many :sections
  has_and_belongs_to_many :groups, {
    join_table: 'sections_users',
    association_foreign_key: 'section_id'
  }
  
  ACQ_FINDER_SQL = ->(*){ %[
      SELECT * FROM users
      INNER JOIN acquaintances
        ON ((users.id = acquaintances.user_id AND acquaintances.other_user_id = #{id})
        OR  (users.id = acquaintances.other_user_id AND acquaintances.user_id = #{id}))
      WHERE (users.deleted_at IS NULL)
  ] }
  
  ACQ_DELETE_SQL = ->(other){ %[
    DELETE FROM acquaintances
    WHERE (user_id = #{id} AND other_user_id = #{other.id})
       OR (user_id = #{other.id} AND other_user_id = #{id})
  ] }
  
  has_and_belongs_to_many :acquaintances, {
    class_name:              'User',
    association_foreign_key: 'other_user_id',
    join_table:              'acquaintances',
    finder_sql:              ACQ_FINDER_SQL,
    delete_sql:              ACQ_DELETE_SQL
  }
  
  def ensure_acquaintances(users)
    diff = users - acquaintances
    for user in diff
      acquaintances << user
    end
  end
  
  def acquainted_to?(u)
    !! User.connection.select_value(%[
      SELECT 1 FROM acquaintances
      WHERE (user_id = #{id} AND other_user_id = #{u.id})
         OR (user_id = #{u.id} AND other_user_id = #{id})
    ])
  end
    
  validates :password_hash, presence: true
  
  validates_length_of :name_prefix, maximum: 50
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name,  presence: true, length: {maximum: 50}
  validates_length_of :name_suffix, maximum: 50
  
  validate :password_validations
  def password_validations  
    if new_record?
      if password_confirmation.blank?
        errors.add(:password_confirmation, t('user.password.confirmation_required'))
      end
      
      if password.blank?
        errors.add(:password, t('user.password.required'))
      end
    end
    
    if password_hash_changed?
      if @raw_password.size <= 7
        errors.add(:password, t('user.password.too_short'))
      end
      
      unless @raw_password == password_confirmation
        errors.add(:password_confirmation, t('user.password.match_confirmation'))
      end
    end
  end
  
  validate :primary_address_validation
  def primary_address_validation
    unless primary_address_id.blank? or addresses.find(primary_address_id)
      errors.add(:primary_address, t('user.address.primary.invalid_id'))
    end
  end  
  
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

  protected
  
  before_save do |user|
    user.phone_numbers.each do |k, v|
      user.phone_numbers[k] = PhoneFormatter.format(v)
    end
  end

  after_save do |user|
    user.password_confirmation_changed = false
  end
  
  after_initialize do |user|
    user.phone_numbers ||= {}
    user.api_token     ||= SecureRandom.hex(32)
  end

  public
  
  def deactivate
    update_attribute :state, 'inactive'
  end
  def activate
    update_attribute :state, 'active'
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def password_confirmation=(pc)
    @password_confirmation_changed = true
    @password_confirmation = pc
  end
  
  def password
    if password_hash.blank?
      ''
    else
      @password ||= BCrypt::Password.new(password_hash)
    end
  end
  
  def password=(new_pass)    
    return false if new_pass.blank?
    @raw_password = new_pass
    self.password_hash = BCrypt::Password.create(new_pass)
    @password = BCrypt::Password.new(password_hash)
  end
  
  def password?(pass)
    password == pass
  end
  
  def notifications
    @notifications ||= NotificationService.new(self)
  end
  
  
  belongs_to :primary_email, class_name: 'Email'
  has_many :emails, foreign_key: 'user_id', primary_key: 'id'

  scope :with_email, ->(email) { joins(:emails).where(emails: {email: email}) }

  def self.with_credentials(email, pass)
    u = User.with_email(email.downcase).first
    u.try(:password?, pass) && u
  end
  
  def add_email(email, active = false)
    self.emails.create(email: email.downcase, state: active ? 'active' : 'inactive').tap do |e|
      self.primary_email = e if primary_email.nil?
    end
  end
  
  def primary_email_address
    self.primary_email.email
  end
  
  def activate_email(email)
    e = self.emails.where(email: email)

    if e
      e.update_attribute :state, 'active'
    end
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
