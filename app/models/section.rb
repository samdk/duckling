class Section < Group
  include Filters
  belongs_to :organization, as: :groupable, polymorphic: true
  has_and_belongs_to_many :users
  
  
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
