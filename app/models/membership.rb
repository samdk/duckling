class Membership < ActiveRecord::Base
  belongs_to :container, polymorphic: true
  belongs_to :user
  
  def admin?
    access_control == 'admin'
  end
  
  def manager?
    access_control == 'manager'
  end
  
  def interested_emails
    ([user] + container.interested_emails).uniq
  end
end