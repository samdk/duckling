class Deployment < ActiveRecord::Base
  belongs_to :activation
  belongs_to :deployed, polymorphic: true
  
  def interested_emails
    deployed.interested_emails
  end
end