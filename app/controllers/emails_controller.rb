class EmailsController < AuthorizedController  
  respond_to :html
  skip_login only: [:create, :new]
  
  def new
    @email = Email.new
  end
  
  def create
    @email = @invite = nil
    ActiveRecord::Base.transaction do
      collection, inviter = logged_in? ? [current_user.emails, current_user.emails] : [Email, nil]
      
      @email = collection.create email: params[:email][:email]
      
      if @email.persisted?
        @invite = @email.invitations.create invitable: inviter, inviter: inviter
        flash[:notice] = t('user.email.success_creating') if @invite.persisted?
      end
    end

    respond_with @email, location: '/'
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
