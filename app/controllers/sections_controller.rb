class SectionsController < AuthorizedController
  layout 'activation_page'
  respond_to :html

  before_filter :set_activation
  before_filter :set_section, except: [:new, :create, :index]

  def new
    @section = Section.new
  end

  def show ; end
  def edit ; end

  def index
    @sections = @activation.sections.all
  end

  def join
    @section.users << current_user
    if @section.authorize_with(@current_user).save
      notice 'section.joined'
    end
    redirect_to :back
  end

  def leave
    @section.users = @section.users - [current_user]
    if @section.authorize_with(current_user).save
      notice 'section.joined'
    end
    redirect_to :back
  end

  def create
    @section = Section.new(params[:section])
    @section.activation = @activation
    @section.users << current_user
    if @section.authorize_with(current_user).save
      notice 'section.created'
      respond_with @activation,@section
    else
      respond_with @activation,@section, location: new_activation_section_path(@activation)
    end
  end

  def update
    if @section.authorize_with(current_user).update_attributes(params[:section])
      notice 'section.updated'
      respond_with @activation,@section
    else
      respond_with @activation,@section, location: edit_activation_section_path(@activation)
    end
  end

  private
    def set_activation
      @activation = current_user.activations.find(params[:activation_id])
      @invitees = current_user.acquaintances
    end

    def set_section
      @section = @activation.sections.find(params[:id])
    end
end
