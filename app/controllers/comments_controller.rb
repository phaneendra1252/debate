class CommentsController < BaseController

  load_and_authorize_resource

  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_url(@comment.article_id), notice: 'Comment was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to article_url(@comment.article_id), notice: 'Comment was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to article_url(@comment.article_id), notice: 'Comment was successfully destroyed.'  }
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
