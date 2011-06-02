class ActivationsController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :set_activation, only: [:edit, :update, :destroy]
  
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
    flash.keep # TODO: is this actually necessary?
    redirect_to activation_updates_path(params[:id])
  end

  def new
    @activation = Activation.new
  end

  def edit ; end

  def create
    orgs = params[:activation].delete(:organizations) & current_user.all_organization_ids
    
    @activation = Activation.new(params[:activation])
    @activation.active = true
    
    @activation.users << current_user
    @activation.organization_ids = orgs
    
    for org in orgs
      for user in Organization.find(org).user_ids
        @activation.user_ids << user
      end
    end
    
    
    # TODO: setup permissions, etc.

    notice 'activation.created' if @activation.save
    
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
  
  private
  def set_activation
    @activation = current_user.activations.find(params[:id])
  end
end
