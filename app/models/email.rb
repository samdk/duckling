class Email < ActiveRecord::Base
  include AuthorizedModel

  validates_presence_of   :email, message: t('user.email.missing')
  validates_uniqueness_of :email, message: t('user.email.unique')
  validates_format_of     :email, message: t('user.email.bad_format'), with: /\A[^@]+@[^@]+\.[^@]+\z/

  scope :active, where(state: 'active')

  belongs_to :user

  has_many :invitations, dependent: :delete_all
  [:organizations, :sections, :activations].each do |table|
    has_many table, through: :invitations, source: :invitable, source_type: table.to_s.classify
  end

  has_many :notifications, dependent: :destroy
  def notify(obj, event)
    notifications.create target: obj, event: event
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

  before_save :fill_in_missing_data
  def fill_in_missing_data
    if attributes.key? 'secret_code'
      self.secret_code ||= SecureRandom.hex(64)
    end
    
    if attributes.key? 'emailed_at'
      self.emailed_at ||= Time.now
    end
  end
end
