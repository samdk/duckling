class Deployment < ActiveRecord::Base
  belongs_to :activation
  belongs_to :deployed, polymorphic: true
  
  def interested_emails
    deployed.interested_emails
  end
  
  after_create :if_for_organization_deploy_all_users
  def if_for_organization_deploy_all_users
    if deployed_type == 'Organization'
      organization.users.find_each(batch_size: 500) do |user|
        activation.users << user
      end
    end
  end
end