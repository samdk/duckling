class Section < ActiveRecord::Base
  include Filters
  
  belongs_to :activation, polymorphic: true, foreign_key: 'groupable_id', foreign_type: 'groupable_type'
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :updates
  
  validates :name, presence: true, length: {within: 2..50}
  validates_length_of :description, maximum: 1000

  include AuthorizedModel
  def permit_create?(user, *)
    user.activations.where(id: activation_id).exists?
  end
  
  alias_method :permit_read?, :permit_create?
  alias_method :permit_update?, :permit_create?
  alias_method :permit_destroy?, :permit_create?

  def to_s
    self.name
  end
end
