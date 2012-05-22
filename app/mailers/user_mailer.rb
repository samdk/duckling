class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  
  default from: 'support@clbt.net'
  
  SUPPORT_EMAILS = %w[eli@clbt.net sam@clbt.net will@clbt.net]
  
  def invite(invitation)
    @invitation = invitation

    subject = if invitation.inviter.nil?
      "Welcome to FlareTeam"
    else
      "#{invitation.inviter.full_name} invites you to FlareTeam"
    end

    mail to: invitation.email.email, subject: subject
  end

  def reset_password(email, user, reset_url)
    @user = user
    @reset_url = reset_url
    
    mail to: email.email, subject: '[FlareTeam] Password Reset Confirmation'
  end

  def notify(user, notifications)
    @notifications = notifications
    
    mail to: email.email, subject: "[FlareTeam] You Have #{pluralize(notifications.size, "Notification")}"
  end
end
