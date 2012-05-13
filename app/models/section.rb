class Section < ActiveRecord::Base
  
  belongs_to :activation, polymorphic: true, foreign_key: 'groupable_id', foreign_type: 'groupable_type'
  
  def activation_id()   groupable_id   end
  def activation_id=(x) groupable_id=x end 
  
  has_many :memberships, as: 'container', dependent: :destroy
  has_many :users, through: :memberships

  has_many :participants, dependent: :destroy
  has_many :updates, through: :participants
  
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
  
  has_many :mappings, class_name: 'Section::Mapping'
  has_many :groups,        through: :mappings, source: :subentity, source_type: 'Group'
  has_many :organizations, through: :mappings, source: :subentity, source_type: 'Organization'
  
  class Mapping < ActiveRecord::Base
    set_table_name 'section_entities'

    belongs_to :section
    belongs_to :subentity, polymorphic: true
    
    def interested_emails
      cond = '(memberships.container_id = ? AND memberships.container_type = "Section") OR ' + 
             '(memberships.container_id = ? AND memberships.container_type = "Group")'
      User.joins(:memberships).where(cond, section.id, group.id)
    end
  end
end
