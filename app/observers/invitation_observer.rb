class InvitationObserver < ActiveRecord::Observer  
  def after_create(invitation)
    invitation.async.deliver
  end
end
