class Invitation < ActiveRecord::Base
  belongs_to :email
  belongs_to :invitable, polymorphic: true
  
  def interested_emails
    [email]
  end
end