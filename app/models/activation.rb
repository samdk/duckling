class Activation < ActiveRecord::Base
  include Filters
  
  acts_as_paranoid
  
  has_many :updates
  has_many :sections, as: :groupable
  
  has_many :deployments
  
  has_many :organization_deployments, as: :deployed
  has_many :organizations, through: :deployments,
                           source: :deployed,
                           source_type: 'Organization'
  
  has_many :user_deployments, as: :deployed
  has_many :users, through: :deployments,
                   source: :deployed,
                   source_type: 'User'
  
  validates :title, presence: true, length: { within: 3..128 }
  validates_length_of :description, maximum: 1024
  
  def interested_emails
    users
  end
  
  include AuthorizedModel
  def permit_create?(user, *)
    true
  end
  
  def permit_read?(user, *)
    !user.blank? and user.deployments.where(activation_id: id).exists?
  end
  
  def permit_update?(user, *)
    permit_read? user
  end
  
  def permit_destroy?(user, *)
    created_at < 5.minutes.ago and permit_read? user
  end
  
  def self.permit_administrate?(id, user)
    join_sql = <<-SQL
      INNER JOIN deployments
              ON (deployments.deployed_id = organizations.id
                  AND deployed_type = "Organization"
                  AND activation_id = %d)
    SQL
    
    user.organizations
        .joins(join_sql % id)
        .where('memberships.access_level <> ""')
        .exists?
  end
  
  
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

  def to_s() title end
end
