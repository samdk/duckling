class EmailsController < AuthorizedController  
  respond_to :html
  skip_login only: [:create, :new]
  
  def new
    @email = Email.new
  end
  
  def create
    if logged_in?
      current_user.emails.create email: params[:email][:email]
      Invitation.create email_id: e.id, invitable: current_user, inviter: current_user
    else
      e = Email.create email: params[:email][:email]
      Invitation.create email_id: e.id
    end
    
    redirect_to '/', notice: t('user.email.check_email')
  end

  def verify
    log_out!
    e = Email.includes(:user).where(secret_code: params[:secret_code]).first!
    unauthorized! if e.user.nil?
    e.activate
    log_in_as e.user
    redirect_to edit_account_url, notice: t('user.email.verified')
  end
  
  def destroy
    email = current_user.emails.find(params[:id])
    email.destroy
    redirect_to edit_account_url, notice: t('user.email.destroyed')
  end
end
