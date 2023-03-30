

class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    # set session initial value
    # +1 session value, for every click
    # if user.view< 3, render max page vie...
    session[:page_views] ||= 0
    session[:page_views] += 1
    
    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
    else
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
