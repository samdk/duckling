class Email < ActiveRecord::Base
  include AuthorizedModel

  validates_presence_of   :email, message: t('user.email.missing')
  validates_uniqueness_of :email, message: t('user.email.unique')
  validates_format_of     :email, message: t('user.email.bad_format'), with: /\A[^@]+@[^@]+\.[^@]+\z/

  scope :active, where(state: 'active')

  belongs_to :user

  has_many :invitations, dependent: :destroy
  [:organizations, :sections, :activations].each do |table|
    has_many table, through: :invitations, source: :invitable, source_type: table.to_s.classify
  end

  has_many :notifications, dependent: :destroy
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
  
  def too_recently_emailed?
    if annoyance_level < 5
      emailed_at < 4.minutes.ago
    else
      level = [8, annoyance_level].min
      emailed_at < (5+1.5**level).to_i.minutes.ago
    end
  end

  before_save :generate_secret_code_if_missing
  def generate_secret_code_if_missing
    @secret_code ||= SecureRandom.base64(128)
  end
end
