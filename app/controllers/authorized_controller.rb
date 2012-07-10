class Unauthorized < RuntimeError ; end 

class AuthorizedController < ApplicationController
  
  before_filter :require_login
  helper_method :current_user, :logged_in?
  
  rescue_from Unauthorized do |exc|
    back_or_403 exc.message
  end
  
  def self.skip_login(opts = {})
    skip_before_filter :require_login, opts
  end

  def require_login
    if logged_in?
      set_time_zone
    elsif request.xhr?
      head 401
    else
      redirect_to login_path(return_to: request.url), notice: t('session.login.required')
    end
  end
  
  def set_time_zone
    Time.zone = current_user.time_zone
  end
  
  attr_accessor :current_user
  
  def logged_in?
    !current_user.nil? or log_in
  end
  
  def log_out!
    reset_session
    cookies.delete :token
    
    self.current_user = nil
  end
  
  def log_in_as(user)
    log_out!
    
    if user.blank?
      false
    else
      self.current_user = user
      user.emails.update_all(annoyance_level: 0)
      session[:user_id] = user.id
      true
    end
  end
  
  def restore_login(user)
    if user.blank?
      false
    else
      self.current_user = user
      true
    end
  end
  
  def log_in
    log_in_from_session or log_in_from_cookie or log_in_from_signature
  end
  
  def remember_with_cookie!
    current_user.update_attributes({
      cookie_token: SecureRandom.base64(128),
      cookie_token_expires_at: Time.now + 2.weeks
    })
    
    cookies[:token] = {
      value:    current_user.cookie_token,
      expires:  current_user.cookie_expires_at,
      secure:   USE_SECURE_COOKIES,
      httponly: true
    }
  end
  
  private
  
  def log_in_from_cookie
    return false unless cookies[:token]
    
    restore_login User.where(cookie_token: cookies[:token]).first
  end
  
  def log_in_from_session
    return false unless session[:user_id]

    restore_login User.where(id: session[:user_id].to_i).first
  end
  
  def log_in_from_signature
    # TODO: HMAC fun stuff here.
    
    false
  end
  
end
