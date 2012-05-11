class Email < ActiveRecord::Base
  include AuthorizedModel

  validates_presence_of   :email, message: t('user.email.missing')
  validates_uniqueness_of :email, message: t('user.email.unique')
  validates_format_of     :email, with: /\A[^@]+@[^@]+\.[^@]+\z/, message: t('user.email.bad_format')  

  belongs_to :user

  def permit_create?(*) true end
  def permit_read?(*)   true end

  def permit_update?(*) ; true ; end
  def permit_destroy?(u, *) ; true ; end

  def activate
    update_attribute :state, 'active'
  end
  
  def active?
    self.state == 'active'
  end

  def to_s
    self.email
  end

  scope :active, ->(){ where(state: 'active') }

end
