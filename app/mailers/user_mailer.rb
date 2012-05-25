class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  
  default from: 'support@clbt.net'
  
  SUPPORT_EMAILS = %w[eli@clbt.net sam@clbt.net will@clbt.net]
  
  def invite(invitation)
    @invitation = invitation
    
    subjects = {
      welcome: 'Welcome to FlareTeam',
      self_invite: '[FlareTeam] Verify your email address',
      other_invite: "#{invitation.inviter.full_name} invites you to FlareTeam"
    }
    
    template = if invitation.inviter.nil?
      :welcome
    elsif invitation.invitable == invitation.inviter
      :self_invite
    else
      :other_invite
    end
    
    invitation.update_attribute :emailed, true

    mail to: invitation.email.email, subject: subjects[template], template: template
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
