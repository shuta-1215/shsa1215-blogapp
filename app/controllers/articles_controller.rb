class ArticlesController < ApplicationController
  def index
    @articles = Article.first
  end
end