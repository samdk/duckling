class UsersController < AuthorizedController
  
  WITHOUT_LOGIN = [:new, :create, :forgot_password,
                   :request_password_reset, :new_password,
                   :reset_password]
  
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
    
    User.transaction do
      if @user.save
        notice 'user.created'
        @user.associate_email(Email.where(secret_code: params[:secret_code]).first)
      end
    end
    
    redirect_to login_url
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
    email = params[:email_address]
    
    u = User.with_email(email).first
    p = PhoneFormatter.format(params[:phone])
    
    if u.phone_numbers.blank? or u.phone_numbers.values.include?(p)
      u.update_attribute(:reset_token, ActiveSupport::SecureRandom.hex(64))
      UserMailer.async.reset_password(email, u, new_passsword_account_url(u.id, u.reset_token))
    end
    
    redirect_to login_url, notice: t('user.password.reset.check_email')
  end
  
  def new_password
    @token = params[:token]
    unless (@user = User.find(params[:id])).reset_token == @token
      redirect_to forgot_password_account_url, error: t('user.password.reset.token_invalid')
    end
  end
  
  def reset_password
    token = params[:token]
    if (user = User.find(params[:id])).reset_token == @token
      user.update_attributes(params[:user])
      log_in_as user
      redirect_to '/', notice: t('user.password.reset.done') # TODO: is this the right path?
    else
      redirect_to :back, error: t('user.password.reset.token_invalid')
    end
  end
  
end
