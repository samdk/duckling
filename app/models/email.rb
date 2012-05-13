class Email < ActiveRecord::Base
  include AuthorizedModel

  validates_presence_of   :email, message: t('user.email.missing')
  validates_uniqueness_of :email, message: t('user.email.unique')
  validates_format_of     :email, message: t('user.email.bad_format'), with: /\A[^@]+@[^@]+\.[^@]+\z/

  scope :active, where(state: 'active')

  belongs_to :user

  has_many :invitations
  [:organizations, :groups, :sections, :activations].each do |table|
    has_many table, through: :invitations, source: :invitable, source_type: table.to_s.classify
  end
  
  has_many :notifications
  def notify(obj, event)
    notifications.create(target_class: obj.class.name, target_id: obj.id, event: event)
  end

  def self.invite(email, obj)
    e = Email.find_or_create_by_email(email)
    if e.user
      e.user.join(obj)
    else
      obj.invitations.create e
    end
  end

  def permit_read?(*)    true end
  def permit_create?(*)  true end
  def permit_update?(*)  true end
  def permit_destroy?(*) true end

  def activate
    update_attribute :state, 'active'
  end
  
  def active?
    self.state == 'active'
  end

  def to_s
    self.email
  end

  before_save :generate_secret_code_if_missing
  def generate_secret_code_if_missing
    @secret_code ||= SecureRandom.base64(128)
  end
end
