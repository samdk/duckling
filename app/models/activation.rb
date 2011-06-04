class Activation < ActiveRecord::Base
  include Filters
  
  is_soft_deleted
  
  has_many :updates
  has_many :groups, as: :groupable
  
  has_many :deployments
  
  has_many :organization_deployments, as: :deployed
  has_many :organizations, through: :deployments,
                           source: :deployed,
                           source_type: 'Organization'
  
  has_many :user_deployments, as: :deployed
  has_many :users, through: :deployments,
                   source: :deployed,
                   source_type: 'User'
  
  validates :title, presence: true, length: { within: 3..50 }
  
  def activate
    update_attributes(active: true, active_or_inactive_since: DateTime.now)
  end
  
  def deactivate
    update_attributes(active: false, active_or_inactive_since: DateTime.now)
  end
  
  def active_since
    active_or_inactive_since or created_at
  end
  alias_method :inactive_since, :active_since
  
end
