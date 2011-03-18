class ActivationsController < AuthorizedController
  def index
    @activations = Activation.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @activation = Activation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @activation = Activation.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @activation = Activation.find(params[:id])
  end

  def create
    @activation = Activation.new(params[:activation])

    respond_to do |format|
      if @activation.save
        format.html { redirect_to(@activation, :notice => 'Activation was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @activation = Activation.find(params[:id])

    respond_to do |format|
      if @activation.update_attributes(params[:activation])
        format.html { redirect_to(@activation, :notice => 'Activation was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @activation = Activation.find(params[:id])
    @activation.destroy

    respond_to do |format|
      format.html { redirect_to(activations_url) }
    end
  end
end
