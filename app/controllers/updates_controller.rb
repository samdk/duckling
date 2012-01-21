class UpdatesController < AuthorizedController
  layout 'activation_page'

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit, :attachment]
  
  before_filter :set_activation, except: [:attachment]
  before_filter :set_update, only: [:edit, :show, :update, :destroy]

  def index
    @updates = @activation.updates
                .includes(:comments, :file_uploads, :author, :activation)
                .order('created_at DESC')
                .in_date_range(params[:start_date], params[:end_date])
                .matching_search(params[:search_query], [:title, :body])
                .matching_joins(:groups, params[:groups_ids])
                #.matching_joins(:organizations, params[:organizations_ids])

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

  def edit
  end

  def create
    @update = @activation.updates.build(params[:update])
    @update.author = current_user

    if @update.authorize_with(current_user).save and handle_sections
      notice 'update.created'
    end
    
    respond_with @activation, @update
  end

  def update
    logger.shout params.inspect
    
    if handle_sections and @update.update_attributes(params[:update])
      notice 'update.updated'
    end
    
    respond_with @activation, @update
  end

  def destroy
    @update.destroy
    destroyed_redirect_to activation_updates_url(@activation)
  end

  def attachment
    # TODO: DANGER DANGER DANGER, can the user access this file?
    send_file FileUpload.find(params[:id]).upload.path
  end

  private
  
  def handle_sections
    if params[:sections]
      @update.section_ids = params[:sections].to_a.filter(&:last).map(&:first)
    end
    true
  end
  
  def set_activation
    @activation = current_user.activations.find(params[:activation_id])
  end
  
  def set_update
    @update = @activation.updates.find(params[:id])
  end
end
