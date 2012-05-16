class Membership < ActiveRecord::Base
  belongs_to :container, polymorphic: true
  belongs_to :user
  belongs_to :creating_user, class_name: 'User'

  def admin?
    access_control == 'admin'
  end

  def manager?
    access_control == 'manager'
  end
  
  def creator
    creating_user or user
  end

  def interested_emails
    ([user, creator] + container.interested_emails).uniq
  end
end