class UsersController < AuthorizedController
  
  WITHOUT_LOGIN = [:new, :create, :request_password_reset, :forgot_password, :verify_email, :request_invitation]
  
  respond_to :html
  respond_to :json, :xml, except: [:edit, *WITHOUT_LOGIN]
  
  skip_login only: WITHOUT_LOGIN
  
  def index
    if params[:activation_id]
      index_activation
    else
      respond_with(@users = current_user.acquaintances)
    end
  end

  def index_activation
    @activation = Activation.includes(users: [:organizations]).find(params[:activation_id])
    
    current_user.ensure_acquaintances(@activation.users)

    @users = @activation.users
                .order('last_name ASC')
                .matching_search([:first_name, :last_name],params[:search_query])

    respond_with(@users, @activation) do |format|
      format.html do
        render :index_activation, layout: 'activation_page'
      end
    end
  end

  def show
    @user = if params[:id].to_i == current_user.id
      current_user
    else
      current_user.acquaintances.includes(:organizations).find(params[:id].to_i)
    end
    
    respond_with @user
  end

  def new
    log_out!

    if (@secret_code = params[:token]).nil?
      redirect_to new_account_email_url
    else
      @email = Email.where(secret_code: params[:token]).first!
      @user = User.new
    end
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
    
    User.transaction do
      if @user.save
        notice 'user.created'
        email = Email.where(secret_code: params[:email_secret_code]).first!
        email.activate
        @user.associate_email(email)
      end
    end
    
    redirect_to login_url, notice: t('user.created')
  end

  def update    
    unless params[:id].blank? or current_user.id == params[:id].to_i
      unauthorized! 'user.update_others' # TODO: is this necessary?
    end
        
    if current_user.authorize_with(current_user).update_attributes(params[:user])
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
  
  def forgot_password ; end
  
  def request_password_reset
    e = Email.includes(:user).where(email: params[:email]).first!

    if e.user
      e.user.reset_reset_token!
      UserMailer.async.reset_password(e)
    end

    redirect_to login_url, notice: t('user.password.reset.check_email')
  end
end
