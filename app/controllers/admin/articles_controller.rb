class Admin::ArticlesController < AdminController

  def index
    @articles = Article.all.includes(:athlete)
  end

  def destroy
    Article.find(params[:id]).destroy
    flash[:success] = "Article has been deleted."
    redirect_to admin_articles_url
  end

end
