class CommentsController < BaseController

  load_and_authorize_resource

  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
  end

  def edit
    render :json => {:success => true, :partial => render_to_string(:partial => 'comments/form', :locals => { comment: @comment })}
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render :json => {:success => true, :partial => render_to_string(:partial => 'comments/comments', :locals => { article: @comment.article })}
    else
      render :json => {:error_fields => @comment.errors, :error_message => @comment.errors.full_messages}, :status => 500
    end
  end

  def update
    if @comment.update(comment_params)
      render :json => {:success => true, :partial => render_to_string(:partial => 'comments/comment', :locals => { comment: @comment })}
    else
      render :json => {:error_fields => @comment.errors, :error_message => @comment.errors.full_messages}, :status => 500
    end
  end

  def destroy
    if @comment.destroy
      render :json => {:success => true, :partial => render_to_string(:partial => 'comments/comments', :locals => { article: @comment.article })}
    else
      render :json => {:error_fields => @comment.errors, :error_message => @comment.errors.full_messages}, :status => 500
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:article_id, :content)
    end

end
