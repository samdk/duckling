class GroupsController < AuthorizedController
  layout 'activation_page'

  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :set_activation
  before_filter :set_group, only: [:edit, :show, :update, :destroy]

  def index
    respond_with @activation, @groups = @activation.groups
  end

  def show
    respond_with @activation, @group
  end

  def new
    @group = Group.new
  end

  def edit ; end

  def create
    @group = @activation.groups.build(params[:group])

    if @group.save
      notice 'group.created'
    end
    
    respond_with @activation, @group
  end

  def update
    if @group.update_attributes(params[:update])
      notice 'group.updated'
    end
    
    respond_with @activation, @group
  end

  def destroy
    @group.destroy
    destroyed_redirect_to activation_groups_url(@activation)
  end

  private
  
  def set_activation
    @activation = current_user.activations.find(params[:activation_id])
  end
  
  def set_group
    @group = @activation.groups.find(params[:id])
  end
end
