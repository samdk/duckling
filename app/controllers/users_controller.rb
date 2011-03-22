class UsersController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  skip_login only: [:create]
  
  def index
    respond_with(@users = current_user.acquaintances)
  end

  def show
    @user = current_user.acquaintances.find_by_id(params[:id])
    ensure_exists @user
    
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
    if !params[:id].blank? and current_user.id != params[:id]
      unauthorized! 'user.update_others'
    end
        
    if current_user.update_attributes(params[:user])
      notice 'user.updated'
    end
    
    respond_with current_user
  end

  def destroy
    if !params[:id].blank? and current_user.id != params[:id]
      unauthorized! 'user.destroy_others'
    end
    
    current_user.destroy
    log_out!

    destroyed_redirect_to login_url
  end
end
