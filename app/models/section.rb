class Section < ActiveRecord::Base
  include Filters
  
  belongs_to :activation, polymorphic: true, foreign_key: 'groupable_id', foreign_type: 'groupable_type'
  
  has_many :memberships, as: 'container'
  has_many :users, through: :memberships

  has_many :participants
  has_many :updates, through: :participants
  
  validates :name, presence: true, length: {within: 2..50}
  validates_length_of :description, maximum: 1000

  include AuthorizedModel
  def permit_create?(user, *)
    user.activations.where(id: activation_id).exists?
  end
  
  alias_method :permit_read?, :permit_create?
  alias_method :permit_update?, :permit_create?

  def to_s
    self.name
  end
end
