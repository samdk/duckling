class UpdatesController < AuthorizedController
  def index
    @activation = Activation.find(params[:activation_id])
    # we want a new variable here because we're (eventually)
    # going to be doing some filtering of updates
    @updates = @activation.updates

    respond_to do |format|
      format.html
    end
  end

  # the default view for an activation is its updates, and the
  # handling of those is managed by the updates controller
  def show
    @update = Update.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @update = Update.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @update = Update.find(params[:id])
  end

  def create
    @update = Update.new(params[:update])

    respond_to do |format|
      if @update.save
        format.html { redirect_to @update, :notice => t('update.create.success') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @update = Update.find(params[:id])

    respond_to do |format|
      if @update.update_attributes(params[:update])
        format.html { redirect_to @update, :notice => t('update.edit.success') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @update = Update.find(params[:id])
    @update.destroy

    respond_to do |format|
      format.html { redirect_to(updates_url) }
    end
  end
end
