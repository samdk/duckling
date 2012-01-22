class UserMailer < ActionMailer::Base
  
  default from: 'support@example.com'
  
  SUPPORT_EMAILS = %w[eli@example.com sam@example.com will@example.com]
  
  def invite(email_address, name, inviter_name, org_name)
    @name, @inviter, @org_name = name, inviter_name, org_name
    
    mail to: email_address,
         from: 'support@example.com',
         subject: "FlareTeam invite from #{@inviter} (#{@org_name})"
  end
  
  def welcome(user)
    @user = user
    @from = SUPPORT_EMAILS.sample
    
    mail to: user.email_addresses.first,
         from: @from,
         subject: 'Welcome to FlareTeam'
  end
  
  def verify_account(user)
    @user = user
    
    mail to: user.email_addresses.first,
         from: 'support@example.com',
         subject: '[FlareTeam] Please verify your account'
  end
  
  def verify_email(email_address, user)
    @user = user
    
    mail to: email_address,
         from: 'support@example.com',
         subject: '[FlareTeam] Please verify your email address'
  end
  
  def reset_password(email_address, user, reset_url)
    @user = user
    @reset_url = reset_url
    
    mail to: email_address,
         from: 'support@example.com',
         subject: '[FlareTeam] Password Reset Confirmation'
  end
  
  def organization_added(organization, user)
    @user = user
    @organization = organization
    
    mail to: user.email_addresses.first,
         from: 'support@example.com',
         subject: "[FlareTeam] You\'ve been added to #{organization.name}"
  end

end
