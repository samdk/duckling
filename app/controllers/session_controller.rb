class SessionController < AuthorizedController 
  
  skip_login only: [:new, :create, :without_password]

  def new
    @return_to = params[:return_to]
  end

  def destroy
    log_out!
    
    notice 'session.logout.success'
    
    redirect_to login_path
  end
  
  def without_password
    u = User.where(reset_token: params[:reset_token]).first!
    log_in_as u
    u.reset_reset_token!
    
    notice 'user.password_reset.do_it'
    redirect_to edit_account_url
  end

  def create
    u = User.with_credentials(params[:email], params[:password])
    
    if u.blank?
      unauthorized! 'session.login.failure'
    elsif !u.login_email.active?
      unauthorized! 'session.login.inactive_email'
    else
      log_in_as u
      
      if params[:secret_code].nil?
        u.associate_email(Email.where(secret_code: params[:secret_code]))
        notice 'email.associated'
      else
        notice 'session.login.success', full_name: u.name
      end
      
      remember_with_cookie! unless params[:cookie].blank?
      
      redirect_to(params[:return_to] || overview_url)
    end
  end

end
