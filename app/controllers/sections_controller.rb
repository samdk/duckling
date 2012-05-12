class SectionsController < AuthorizedController
  layout 'activation_page'

  before_filter :set_activation
  before_filter :set_section, except: [:new, :index]

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
    if @section.save
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
    @section.users << current_user
    if @section.authorize_with(current_user).save
      notice 'section.created'
      respond_with @section
    else
      respond_with @section, location: new_activation_section_path(@activation)
    end
  end

  def update
    if @section.update_attributes(params[:section])
      notice 'section.updated'
      respond_with @section
    else
      respond_with @section, location: edit_activation_section_path(@activation)
    end
  end

  private
    def set_activation
      @activation = current_user.activations.find(params[:activation_id])
    end

    def set_section
      @section = @activation.sections.find(params[:id])
    end
end
