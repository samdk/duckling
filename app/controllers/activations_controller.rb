class ActivationsController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :setup_activation, only: [:edit, :update, :destroy]
  
  def index
    # TODO: filters here.
    
    respond_with(@activations = current_user.activations)
  end

  # the default view for an activation is its updates, and the
  # handling of those is managed by the updates controller
  def show
    flash.keep
    redirect_to activation_updates_path(params[:id])
  end

  def new
    @activation = Activation.new
  end

  def edit
    respond_with @activation
  end

  def create
    @activation = Activation.new(params[:activation])

    if @activation.save
      notice 'activation.created'
      # TODO: associate to orgs, people, etc.
    end
    
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
  def setup_activation
    @activation = current_user.activations.find_by_id(params[:id])
    ensure_exists @activation
  end
end
