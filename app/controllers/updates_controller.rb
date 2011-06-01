class UpdatesController < AuthorizedController
  layout 'activation_page'

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :set_activation
  before_filter :set_update, only: [:edit, :show, :update, :destroy]

  def index
    # we want a new variable here because we're (eventually)
    # going to be doing some filtering of updates
    @updates = @activation.updates

    respond_with @activation, @updates
  end

  # the default view for an activation is its updates, and the
  # handling of those is managed by the updates controller
  def show
    respond_with @activation, @update
  end

  def new
    @update = Update.new
  end

  def edit ; end

  def create
    @update = Update.new(params[:update])

    if @update.save
      # TODO: associate to things
      notice 'update.created'
    end
    
    respond_with @activation, @update
  end

  def update
    if @update.update_attributes(params[:update])
      notice 'update.updated'
    end
    
    respond_with @activation, @update
  end

  def destroy
    @update.destroy
    destroyed_redirect_to activations_updates_url(@activation)
  end

  private
  
  def set_activation
    @activation = current_user.activations.find(params[:activation_id])
  end
  
  def set_update
    @update = @activation.updates.find(params[:id])
  end
end
