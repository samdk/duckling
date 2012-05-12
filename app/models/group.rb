class Group < Section
  include Filters
  belongs_to :organization, foreign_key: 'groupable_id', polymorphic: true, foreign_type: 'groupable_type'

  has_many :memberships, as: 'container'
  has_many :users, through: :memberships
  
  include AuthorizedModel
  def permit_create?(user, *)
    user.organizations.where(id: organization_id).exists?
  end
  
  alias_method :permit_read?, :permit_create?
  
  def permit_update?(user, *)
    user.sections.where(id: id).exists? or user.manages?(organization_id)
  end
  
  def permit_destroy?(user, *)
    user.manages?(organization_id)
  end
  
end
