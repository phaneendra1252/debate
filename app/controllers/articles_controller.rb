class ArticlesController < BaseController

  load_and_authorize_resource

  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.all
    @articles = Kaminari.paginate_array(@articles).page(params[:page]).per(5)
  end

  def show
    @comment = Comment.new(:article => @article)
  end

  def new
    @article = Article.new(author_name: current_user.name)
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    respond_to do |format|
      if @article.save
        format.html { redirect_to articles_url, notice: 'Article was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to articles_url, notice: 'Article was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
    end
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:name, :content, :author_name)
    end

end
