class Membership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  
  def admin?
    access_control == 'admin'
  end
  
  def manager?
    access_control == 'manager'
  end 
end