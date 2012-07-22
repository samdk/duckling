class ActivationsController < AuthorizedController

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit, :overview]
  
  before_filter :set_activation, only: [:edit, :update, :destroy]
  
  def overview
    @activations = current_user.activations
                    .in_date_range(params[:start_date] || 10.years.ago, params[:end_date].presence || 10.years.from_now)
                    .matching_search(params[:search_query], [:title, :description])
                    .matching_joins(:organizations, params[:organization_ids])
                    .select('activations.id, activations.created_at, activations.updated_at, activations.description, activations.title, activations.updates_count, activations.deleted_at')
  end
  
  def index
    @activations = current_user.activations
                    .in_date_range(params[:start_date] || 10.years.ago, params[:end_date].presence || 10.years.from_now)
                    .matching_search(params[:search_query], [:title, :description])
                    .matching_joins(:organizations, params[:organization_ids])
                    .select('activations.id, activations.created_at, activations.updated_at, activations.description, activations.title, activations.updates_count, activations.deleted_at')
    
    respond_with @activations
  end

  # the default view for an activation is its updates, and the
  # handling of those is managed by the updates controller
  def show
    redirect_to activation_updates_path(params[:id])
  end

  def new
    @activation = Activation.new
  end

  def edit ; end

  def create    
    @activation = Activation.new(params[:activation])
    @activation.active = true

    @activation.users << current_user

    # TODO: setup permissions, etc.

    notice 'activation.created' if @activation.authorize_with(current_user).save
    
    respond_with @activation
  end

  def update
    if @activation.update_attributes(params[:activation])
      notice 'activation.updated'
    end
    
    respond_with @activation
  end

  def destroy
    @activation.destroy
    destroyed_redirect_to activations_url
  end
  
  def leave
    a = Activation.find(params[:activation_id])
    current_user.activations.delete(a)

    respond_to do |wants|
      wants.html { redirect_to activations_path }
      wants.any  { head :ok }
    end
  end
  
  def revoke
    unless @activation.memberships.where(access_control: 'admin', user_id: current_user.id).exists?
      unauthorized! 'activation.revoke.unauthorized'
    end

    if params[:email]
      email = Email.where(email: params[:email])
      @activation.invitiations.where(email_id: email.id).clear
    elsif params[:user_id]
      @activation.users.where(user_id: params[:user_id]).clear
    end
    
    redirect_to @activation, notice: t('activation.revoke.success')
  end
  
  def organization_leave
    
  end
  
  private
  def set_activation
    @activation = current_user.activations.find(params[:id])
    @activation.authorize_with current_user
  end
end
