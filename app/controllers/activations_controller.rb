class ActivationsController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :set_activation, only: [:edit, :update, :destroy]
  
  def index
    # TODO: filters here.
    
    respond_with(@activations = current_user.activations)
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
  def set_activation
    @activation = current_user.activations.find(params[:id])
  end
end
