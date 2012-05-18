class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  
  default from: 'support@clbt.net'
  
  SUPPORT_EMAILS = %w[eli@clbt.net sam@clbt.net will@clbt.net]
  
  def invite(invitation)
    @invitation = invitation
    
    mail to: invitation.email.email,
         subject: "FlareTeam invite from #{invitation.inviter.full_name}"
  end
  
  def welcome(user)
    @user = user
    @from = SUPPORT_EMAILS.sample
    
    mail to: user.primary_email_address,
         subject: 'Welcome to FlareTeam'
  end

  def verify_email(email, user = nil)
    @user = user
    
    mail to: email.email,
         subject: '[FlareTeam] Please verify your email address'
  end
  
  def reset_password(email, user, reset_url)
    @user = user
    @reset_url = reset_url
    
    mail to: email.email,
         subject: '[FlareTeam] Password Reset Confirmation'
  end
  
  def notify(user, notifications)
    @notifications = notifications
    
    mail to: email.email, 
         subject: "[FlareTeam] You Have #{pluralize(notifications.size, "Notification")}"
  end

end
