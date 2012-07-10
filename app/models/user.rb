class User < ActiveRecord::Base

  def serializable_hash(opts)
    opts[:except] = Array.wrap(opts[:except]) + %w[
      api_token
      created_at deleted_at updated_at time_zone
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

  attr_accessor :password_confirmation, :password_confirmation_changed, :login_email

  attr_accessible :first_name, :last_name, :name_prefix, :name_suffix,
    :phone_numbers, :primary_address_id, :password, :password_confirmation, :time_zone

  THUMBS = {styles: {large: ['100x100#', :png], small: ['60x60#', :png]},
            default_url: '/assets/avatars/default_:style_avatar.png',
            default_style: :small,
            url: '/people/:id/avatar_:style.png',
            path: ':rails_root/attachments/avatars/:style/:id.png'}.freeze
  has_attached_file :avatar, FILE_STORAGE_OPTS.merge(THUMBS)
  validates_length_of :avatar_file_name, maximum: 100

  serialize :phone_numbers, Hash

  has_many :addresses, dependent: :delete_all
  belongs_to :primary_address, class_name: 'Address'
  
  belongs_to :primary_email, class_name: 'Email'
  has_many :emails, foreign_key: 'user_id', primary_key: 'id', dependent: :destroy

  scope :with_email, ->(email) { joins(:emails).where(emails: {email: email}) }

  has_many :memberships, dependent: :destroy
  has_many :activations,   through: :memberships, source: 'container', uniq: true, source_type: 'Activation'
  has_many :sections,      through: :memberships, source: 'container', uniq: true, source_type: 'Section'
  has_many :organizations, through: :memberships, source: 'container', uniq: true, source_type: 'Organization'

  belongs_to :primary_organization, class_name: 'Organization'

  has_many :notifications, dependent: :delete_all
  def notify(obj, event)
    notifications.create target: obj, event: event
  end

  def send_invite_to(email, obj)
    e = Email.find_or_create_by_email(email)
    if e.user
      e.user.join(obj)
    else
      Invitation.create email: e, invitable: obj, inviter: self
    end
  end
  
  def join(obj)
    obj.users << self unless obj.users.exists?(id)
  end  

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
    diff = Array(users) - acquaintances
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
    m = org.memberships.where(user_id: id).first_or_initialize
    m.update_attribute :access_level, 'admin'
  end

  def manage(org)
    m = org.memberships.where(user_id: id).first_or_initialize
    m.update_attribute :access_level, 'manager'
  end
  
  def administrates?(org)
    org.memberships.where(user_id: id, access_level: 'admin').exists?
  end

  def manages?(org)
    org.memberships.where(user_id: id).where("access_level <> ''", org_id).exists?
  end
  
  def try_to_associate(target, source)
    return unless can? read: target # TODO: is this right?
    return unless can? read: source
    return unless target.users.exists?(id)

    association_name = source.class.table_name
    association_proxy = target.send(association_name)
    
    unless association_proxy.exists?(source.id)
      association_proxy << source
    end
  end

  protected
  
  before_save :format_phone_numbers
  after_initialize :set_default_api_token_and_phone_hash
  
  def format_phone_numbers
    phone_numbers.each do |k, v|
      self.phone_numbers[k] = PhoneFormatter.format(v)
    end
  end


  def set_default_api_token_and_phone_hash
    self.phone_numbers ||= {} if attributes.key? :phone_numbers
    self.api_token ||= SecureRandom.hex(32) if attributes.key? :api_token
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

  def self.with_credentials(email, pass)
    e = Email.includes(:user).where(email: email.downcase).first
    
    return false if !e || !e.user

    u = e.user
    u.login_email = e
    
    u.password?(pass) && u
  end
  
  def add_email(email, active = false)
    check_permits
    
    e = emails.where(email: email.downcase).first_or_create(state: active ? 'active' : 'inactive')
    if primary_email.nil?
      self.primary_email = e
      save
    end
  end

  def associate_email(e)
    emails << e
    
    self.primary_email_id = e.id if primary_email_id.nil?
    
    e.invitations.includes(:invitable).find_each do |invite|
      unless invite.invitable.nil? or invite.invitable.users.exists?(id)
        invite.invitable.users << self
      end
    end
    e.invitations.delete_all
  end

  def primary_email_address
    primary_email.nil? ? '' : primary_email.email
  end
  
  def activate_email(email)
    self.emails.where(email: email).update_all(state: 'active')
  end
  
  def name
    [name_prefix,first_name,last_name,name_suffix].join(' ').strip.gsub(/\s+/, ' ')
  end

  def can?(hash, args = {})
    hash.all? do |action, object|
      object.send "permit_#{action}?", self, args
    end
  end

  def to_s
    name
  end

  def interested_emails
    primary_email
  end
  
  def reset_reset_token!
    update_attribute :reset_token, SecureRandom.hex(64)
  end
  
end
