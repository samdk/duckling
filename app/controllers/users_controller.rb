class UsersController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  skip_login only: [:create]  
  
  def index
    respond_with(@users = current_user.acquaintances)
  end

  def index_activation
    @activation = Activation.find(params[:activation_id])
    respond_with(@users = @activation.users,@activation) do |format|
      format.html do
        render layout: 'activation_page'
      end
    end
  end

  def show
    @user = current_user.acquaintances.find(params[:id])
    respond_with @user
  end

  def new
    @user = User.new
  end

  def edit
    unless params[:id].blank? or current_user.id == params[:id]
      unauthorized! 'user.edit_others'
    end
    
    @user = current_user
  end

  def create
    log_out!
    
    @user = User.new(params[:user])

    unless params[:password].blank?
      pc = :password_confirmation
      if params[pc].blank?
        @user.errors.add(pc, t('login.password_confirmation.missing'))
      elsif params[:password] != params[pc]
        @user.errors.add(pc, t('login.password_confirmation.wrong'))
      end
    end
    
    notice 'user.created' if @user.save
          
    respond_with @user
  end

  def update
    unless params[:id].blank? or current_user.id == params[:id]
      unauthorized! 'user.update_others'
    end
        
    if current_user.update_attributes(params[:user])
      notice 'user.updated'
    end
    
    respond_with(@user = current_user)
  end

  def destroy
    unless params[:id].blank? or current_user.id == params[:id]
      unauthorized! 'user.destroy_others'
    end
    
    current_user.destroy
    log_out!

    destroyed_redirect_to login_url
  end
  
  def avatar    
    u = current_user.acquaintances.find(params[:id])

    if u.avatar.file?
      send_file u.avatar.path(params[:style]), disposition: 'inline', url_based_filename: true
    else
      redirect_to u.avatar.url
    end

  end
end
