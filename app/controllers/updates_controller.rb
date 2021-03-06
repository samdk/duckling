class UpdatesController < AuthorizedController
  layout 'activation_page'

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit, :attachment]
  
  before_filter :set_activation, except: [:index, :attachment]
  before_filter :set_update, only: [:edit, :show, :update, :destroy]

  def index
    @activations = current_user.activations.includes(users: [:primary_email], sections: [])
    
    @activation = @activations.find(params[:activation_id])

    @updates = @activation.updates
                .includes(:comments, :attachments, :author)
                .order('created_at DESC')
                .in_date_range(params[:start_date] || 10.years.ago, params[:end_date] || 10.years.from_now)
                .matching_search([:title, :body], params[:search_query])

    current_user.ensure_acquaintances @activation.users

    @invitees = current_user.acquaintances.includes(:primary_email)
    @update = Update.new

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
    @update.author = @current_user
    @update.attachments.each {|a| a.attachable = @update}
    notice 'update.created' if @update.authorize_with(current_user).save

    respond_with @activation, @update
  end

  def update
    save = @update.authorize_with(current_user).update_attributes(params[:update])
    notice 'update.updated' if save
   
    respond_with @activation
  end

  def destroy
    @update.destroy
    destroyed_redirect_to activation_updates_url(@activation)
  end

  private

  def set_activation
    @activation = current_user.activations.find(params[:activation_id])
  end

  def set_update
    set_activation if @activation.blank?
    @update = @activation.updates.includes(:attachments).find(params[:id])
  end
end
