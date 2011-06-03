class Organization < ActiveRecord::Base
  include Filters
  is_soft_deleted
  
  has_many :deployments, as: :deployed
  has_many :activations, through: :deployments
  has_many :current_activations, through: :deployments, conditions: {active: true}
  has_many :past_activations, through: :deployments, conditions: {active: true}
  
  has_and_belongs_to_many :administrators, class_name: 'User'
  has_and_belongs_to_many :managers,       class_name: 'User'
  has_and_belongs_to_many :users
  
  has_many :sections, as: :groupable
  
  validate :has_at_least_one_administrator
  def has_at_least_one_administrator
    if administrators.empty?
      errors.add(:administrators, 'must be present')
    end
  end
  
  validates :name, presence: true,
                   length: {minimum: 3},
                   uniqueness: true,
                   format: {with: /[A-Za-z0-9\-_]+/}
  
  def to_s
    self.name
  end
end
