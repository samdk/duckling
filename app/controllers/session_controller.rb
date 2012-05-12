class SessionController < AuthorizedController 
  
  skip_login only: [:new, :create]

  def new
    @return_to = params[:return_to]
  end

  def destroy
    log_out!
    
    notice 'session.logout.success'
    
    redirect_to login_path
  end

  def create
    u = User.with_credentials(params[:email], params[:password])
    
    if u.blank?
      unauthorized! 'session.login.failure'
    elsif !u.login_email.active?
      unauthorized! 'session.login.inactive_email'
    else
      log_in_as u
      
      remember_with_cookie! unless params[:cookie].blank?
      
      notice 'session.login.success', full_name: u.name
      
      redirect_to(params[:return_to] || overview_url)
    end
  end

end
