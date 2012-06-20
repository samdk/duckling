class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  
  default from: 'support@clbt.net'
  
  SUPPORT_EMAILS = %w[eli@clbt.net sam@clbt.net will@clbt.net]
  
  def invite(invitation)
    @invitation = invitation
  
    subject, template = if invitation.inviter.nil?
      ['Welcome to FlareTeam', :welcome]
    elsif invitation.invitable == invitation.inviter
      ['[FlareTeam] Verify your email address', :self_invite]
    else
      ["#{invitation.inviter.full_name} invites you to FlareTeam", :other_invite]
    end
    
    invitation.update_attribute :emailed, true
    mail to: invitation.email.email, subject: subject, template_name: template
  end

  def reset_password(email)
    @reset_token = email.user.reset_token
    mail to: email.email, subject: '[FlareTeam] Password Reset Confirmation'
  end

  def notify(user, notifications)
    @notifications = notifications
    
    mail to: email.email, subject: "[FlareTeam] You Have #{pluralize(notifications.size, "Notification")}"
  end
end
