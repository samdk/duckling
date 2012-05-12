class Email < ActiveRecord::Base
  include AuthorizedModel

  validates_presence_of   :email, message: t('user.email.missing')
  validates_uniqueness_of :email, message: t('user.email.unique')
  validates_format_of     :email, with: /\A[^@]+@[^@]+\.[^@]+\z/, message: t('user.email.bad_format')  

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

  def permit_create?(*)  true end
  def permit_read?(*)    true end
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


end
