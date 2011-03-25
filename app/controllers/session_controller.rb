class SessionController < AuthorizedController 
  
  skip_login only: [:new, :create]

  def new
  end

  def destroy
    log_out!
  end

  def create
    u = User.with_credentials(params[:email], params[:password])
    if u.blank?
      unauthorized! 'login.failure'
    else
      log_in_as(u)
      # TODO: is this sensible?
      
      notice 'login.success', u.name
      redirect_to activations_url
    end
  end

end
