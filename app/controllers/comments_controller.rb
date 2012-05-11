class CommentsController < AuthorizedController
  
  respond_to :html
  respond_to :json, :xml, except: [:new, :edit]
  
  before_filter :set_activation_and_update
  before_filter :set_comment, only: [:edit, :update, :destroy]
  
  # we never see comments on their own, always in the context of an update
  def index
    redirect_to activation_update_path(@activation, @update)
  end

  def show    
    respond_with @comment do |format|
      format.html { redirect_to "#{activation_update_path(@activation,@update)}#comment-#{params[:id]}" }
    end
  end

  def new
    @comment = Comment.new
  end

  def edit ; end

  def create
    ActiveRecord::Base.transaction do
      @comment = @update.comments.build(params[:comment])
      @comment.author = @current_user
      attach = @comment.attachment
      @comment.attachment = nil
      if @comment.authorize_with(current_user).save && attach
        attach.attachable = @comment
        notice 'comment.created' if attach.authorize_with(current_user).save
      end
    end
    
    respond_with @activation, @update, @comment do |format|
      format.html do 
        if request.xhr?
          if @comment.persisted?
            render 'show', layout: false
          else
            render text: "Invalid comment", status: 400
          end
        else
          redirect_to :back
        end
      end    
      format.any { head :ok }
    end
  end

  #def update
  #  notice 'comment.updated' if @comment.authorize_with(current_user).update_attributes(params[:comment])

  #  respond_with @activation, @update, @comment do |format|
  #    format.html { redirect_to :back }
  #    format.any { head :ok }
  #  end
  #end

  def destroy
    @comment.authorize_with(current_user).destroy
    destroyed_redirect_to :back
  end
  
  private
  def set_activation_and_update
    @activation = current_user.activations.find(params[:activation_id])
    @update = @activation.updates.find(params[:update_id])
  end

  def set_comment
    @comment = @update.comments.includes(:author, :update).find(params[:id])
  end
end
