class UpdatesController < AuthorizedController
  layout 'activation_page'

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :set_activation
  before_filter :set_update, only: [:edit, :show, :update, :destroy]

  def index
    @updates = @activation.updates
                .order('created_at DESC')
                .in_date_range(params[:start_date], params[:end_date])
                .matching_search(params[:search_query], [:title, :body])
                .matching_joins(:tags, params[:tag_ids])

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
    params[:groups].each_pair do |k,v|
      @update.groups << Group.find(k) if v
    end

    if @update.save
      # TODO: associate to things
      notice 'update.created'
    end
    
    respond_with @activation, @update
  end

  def update
    @update.groups.clear
    params[:groups].each_pair do |k,v|
      @update.groups << Group.find(k) if v
    end

    if @update.update_attributes(params[:update])
      notice 'update.updated'
    end
    
    respond_with @activation, @update
  end

  def destroy
    @update.destroy
    destroyed_redirect_to activations_updates_url(@activation)
  end

  def attachment
    attach_id, filename = params.slice(:attach_id, :filename)
    
    # TODO: can the user access this file?
    
    send_file @update.file_uploads.find(attach_id).upload.path
  end

  private
  
  def set_activation
    @activation = current_user.activations.find(params[:activation_id])
  end
  
  def set_update
    @update = @activation.updates.find(params[:id])
  end
end
