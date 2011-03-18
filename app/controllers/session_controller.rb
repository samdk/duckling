class SessionController < AuthorizedController 
  
  skip_login({:only => [:new, :create]})

  def new
  end

  def destroy
    log_out!
  end

  def create
    u = User.with_credentials(params[:email],params[:password])
    if u
      log_in_as(u)
      redirect_to '/'
    else
      redirect_to :back
    end
  end

end
