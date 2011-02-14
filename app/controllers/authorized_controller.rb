class AuthorizedController < ApplicationController
  
  before_filter :require_login
  helper_method :current_user, :logged_in?
  
  def self.skip_authorization
    skip_before_filter :require_login
  end
  
  def require_login
    unless logged_in?
      redirect_to login_path, notice:    t('session.login.required'),
                              return_to: request.url
    end
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
      session[:user_id] = user.id
      true
    end
  end
  
  def log_in
    log_in_from_session or log_in_from_cookie
  end
  
  def remember_with_cookie!
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
    
    log_in_as User.where(cookie_token: cookies[:token]).first
  end
  
  def log_in_from_session
    return false unless session[:user_id]
    
    log_in_as User.find(session[:user_id].to_i)
  end
end
