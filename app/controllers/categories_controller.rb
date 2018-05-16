class CategoriesController < ApplicationController
before_action :set_category, only: [:show, :edit, :update, :delete]
 before_action :set_splash, only: [:show, :new, :create, :new_article]
  before_action :set_article, only: [:show, :new, :new_article]
COLORS = ["green", "orange", "yellow", "blue", "purple", "red"]



  def show
    @categories = current_user.categories.order(created_at: :desc)
    @articles = @category.articles
    if params[:query]
      @articles = @articles.search_by_title_and_content(params[:query])
    end
  end

  def new
    @category = Category.new
  end

  def new_article

  end
  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    if @category.save
      id = @category.id
       n = COLORS.count
       x = id/n
       y = id - n * x
       @category.color = COLORS[y]
       @category.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @category.update(category_params)
      redirect_to category_path(@category)
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:format])
    @category.destroy
    redirect_to root_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
  def set_splash
    if Category.first
      @categories = current_user.categories.order(created_at: :desc)
      @splash = []
      @categories.each do |category|
        @splash << [category.name, category.id]
      end
    end
  end

   def set_article
    @article = Article.new
   end
end
