class SessionController < AuthorizedController 
  
  skip_login only: [:new, :create]

  def new
  end

  def destroy
    log_out!
    
    notice 'logout.success'
    
    redirect_to login_path
  end

  def create
    u = User.with_credentials(params[:email], params[:password])
    if u.blank?
      unauthorized! 'login.failure'
    else
      log_in_as(u)
      
      remember_with_cookie! unless params[:cookie].blank?
      
      notice 'login.success', u.name
      
      # TODO: is this a good url?
      redirect_to activations_url
    end
  end

end
