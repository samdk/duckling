class Section < ActiveRecord::Base
  belongs_to :activation
  
  has_many :memberships, as: 'container', dependent: :destroy
  has_many :users, through: :memberships

  has_many :update_mappings, class_name: 'Mapping::SectionUpdate', dependent: :destroy
  has_many :updates, through: :update_mappings
  
  validates :name, presence: true, length: {within: 2..50}
  validates_length_of :description, maximum: 1000

  include AuthorizedModel
  def permit_create?(user, *)
    activation.users.exists?(user.id)
  end
  
  alias_method :permit_read?, :permit_create?
  alias_method :permit_update?, :permit_create?

  def to_s
    self.name
  end
  
  has_many :organization_mappings, class_name: 'Mapping::OrganizationSection', dependent: :destroy
  has_many :organizations, through: :organization_mappings
  
  def interested_emails
    users
  end
end
