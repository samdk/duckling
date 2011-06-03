class Activation < ActiveRecord::Base
  include Filters
  is_soft_deleted
  
  has_many :updates
  has_many :groups, as: :groupable
  
  has_many :deployments
  
  has_many :organization_deployments, as: :deployed
  has_many :organizations, through: :deployments, source: :organization, conditions: 'deployments.deployed_type = "Organization"'
  
  has_many :user_deployments, as: :deployed
  has_many :users, through: :deployments, source: :user, conditions: 'deployments.deployed_type = "User"'
  
  validates :title, presence: true, length: { within: 3..50 }
  
  def activate
    update_attributes(active: true, activation_changed_at: DateTime.now)
  end
  
  def deactivate
    update_attributes(active: false, activation_changed_at: DateTime.now)
  end
  
  def active_since
    activation_changed_at or created_at
  end
  alias_method :inactive_since, :active_since
  
end
