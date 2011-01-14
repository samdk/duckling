class ActivationsController < ApplicationController
  # GET /activations
  # GET /activations.xml
  def index
    @activations = Activation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activations }
    end
  end

  # GET /activations/1
  # GET /activations/1.xml
  def show
    @activation = Activation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activation }
    end
  end

  # GET /activations/new
  # GET /activations/new.xml
  def new
    @activation = Activation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activation }
    end
  end

  # GET /activations/1/edit
  def edit
    @activation = Activation.find(params[:id])
  end

  # POST /activations
  # POST /activations.xml
  def create
    @activation = Activation.new(params[:activation])

    respond_to do |format|
      if @activation.save
        format.html { redirect_to(@activation, :notice => 'Activation was successfully created.') }
        format.xml  { render :xml => @activation, :status => :created, :location => @activation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activations/1
  # PUT /activations/1.xml
  def update
    @activation = Activation.find(params[:id])

    respond_to do |format|
      if @activation.update_attributes(params[:activation])
        format.html { redirect_to(@activation, :notice => 'Activation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activations/1
  # DELETE /activations/1.xml
  def destroy
    @activation = Activation.find(params[:id])
    @activation.destroy

    respond_to do |format|
      format.html { redirect_to(activations_url) }
      format.xml  { head :ok }
    end
  end
end
