class Invitation < ActiveRecord::Base
  belongs_to :email
  belongs_to :invitable, polymorphic: true
  belongs_to :inviter, class_name: 'User'
  
  def interested_emails
    [email]
  end
end