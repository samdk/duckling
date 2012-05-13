class Group < ActiveRecord::Base
  belongs_to :organization, foreign_key: 'groupable_id', polymorphic: true, foreign_type: 'groupable_type'

  def organization_id()   groupable_id   end
  def organization_id=(x) groupable_id=x end 

  has_many :memberships, as: 'container'
  has_many :users, through: :memberships
  
  has_many :mappings, class_name: 'Section::Mapping', as: :subentity
  has_many :sections, through: :mappings
  
  include AuthorizedModel
  def permit_create?(user, *)
    user && user.organizations.where(id: organization_id).exists?
  end
  
  alias_method :permit_read?, :permit_create?
  
  def permit_update?(user, *)
    user.sections.where(id: id).exists? or user.manages?(organization_id)
  end
  
  def permit_destroy?(user, *)
    user.manages?(organization_id)
  end
  
end
