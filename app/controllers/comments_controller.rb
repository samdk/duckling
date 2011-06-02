class CommentsController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :set_activation
  before_filter :set_update
  before_filter :set_comment, only: [:edit, :update, :destroy]
  
  # we never see comments on their own, always in the context of an update
  def index
    redirect_to activation_update_path(@activation,@update)
  end

  def show
    redirect_to "#{activation_update_path(@activation,@update)}#comment-#{params[:id]}"
  end

  def new
    @comment = Comment.new
  end

  def edit ; end

  def create
    @comment = @update.comments.build(params[:comment])
    @comment.author = @current_user

    if @comment.save
      notice 'comment.created'
    end
    respond_with @activation,@update,@comment do |format|
      format.html { redirect_to :back }
    end
  end

  def update
    notice 'comment.updated' if @comment.update_attributes(params[:comment])
    respond_with @activation,@update,@comment
  end

  def destroy
    @comment.destroy
    destroyed_redirect_to :back
  end
  
  private
  def set_activation
    @activation = current_user.activations.find(params[:activation_id])
  end
  def set_update
    @update = @activation.updates.find(params[:update_id])
  end
  def set_comment
    @comment = @update.comments.find(params[:id])
  end
end
