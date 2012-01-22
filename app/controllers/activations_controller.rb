class ActivationsController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit, :overview]
  
  before_filter :set_activation, only: [:edit, :update, :destroy]
  
  def overview
    
  end
  
  def index
    @activations = current_user.activations
                    .in_date_range(params[:start_date], params[:end_date])
                    .matching_search(params[:search_query], [:title, :description])
                    .matching_joins(:organizations, params[:organization_ids])
    
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
  
  def rejoin
    deployment = current_user.deployments.where(activation_id: params[:activation_id]).first!
    deployment.update_attribute(:active, true)
    
    respond_with @activation
  end
  
  def leave
    deployment = current_user.deployments.where(activation_id: params[:activation_id]).first!
    deployment.update_attribute(:active, false)
    
    respond_to do |wants|
      wants.html { redirect_to activations_path }
      wants.any  { head :ok }
    end
  end
  
  def organization_leave
    
  end
  
  private
  def set_activation
    @activation = current_user.activations.find(params[:id])
  end
end
