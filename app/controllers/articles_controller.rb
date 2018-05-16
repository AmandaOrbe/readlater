class ArticlesController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  before_action :set_splash, only: [:index, :new, :create]
  before_action :set_article, only: [:index, :new]

  def index
    if Article.first
      @articles = current_user.articles.order(created_at: :desc)
      if params[:query]
        @articles = @articles.search_by_title_and_content(params[:query])
      end
    end

  end


  def new

  end

  def create
      @article = Article.new(article_params)
      @article.user_id = current_user.id
      url = @article.url
      # begin
        html_file = open(url).read
        html_doc = Nokogiri::HTML(html_file)
      # rescue
      #   html_file = open('https://' + url).read
      #   html_doc = Nokogiri::HTML(html_file)
      # rescue
      #   html_file = open('https://' + url).read
      #   html_doc = Nokogiri::HTML(html_file)
      # rescue
      #   html_doc = url
      # end
      set_title(html_doc, url)
      set_description(html_doc, url)
      set_image(html_doc, url)
      set_content(html_doc, url)
      # @article.image = "ux-animations1.png"
      # photo_url = html_doc.css("meta[property='og:image']").first.attributes["content"]
      # @article.image = URI.parse(photo_url)
      # if @article.image == nil
      #   @article.image = "ux-animations1.png"
      # end
      #
-
    # self.photo = URI.parse(photo_url)
    # self.sav

    if @article.save
      category = @article.category_id
      redirect_to category_path(category)
    else
      raise
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @article = Article.find(params[:format])
    @article.destroy
    redirect_to root_path
  end

private
  def set_content(html_doc, url)
    @article.content = html_doc.search('body').first.text.strip
  end
  def set_image(html_doc, url)
    if html_doc.css("meta[property='og:image']").first
      photo_url = html_doc.css("meta[property='og:image']").first.attributes["content"]
       @article.image = URI.parse(photo_url)
        if @article.image[0..3] != "http"
          @article.image = url + "/" + @article.image
        end
    else
      photo_url = "ux-animations1.png"
      @article.image = URI.parse(photo_url)
    end

  end

  def set_description(html_doc, url)
    if html_doc.css("meta[property='og:description']").first
        @article.description = html_doc.css("meta[property='og:description']").first.attributes["content"].value
    elsif html_doc.search('p').first
      @article.description = html_doc.search('p').first.text.strip
    elsif html_doc.search('h2', 'h3', 'h4', 'h5').first
      @article.description = html_doc.search('h2', 'h3', 'h4', 'h5').first.text.strip
    else
    @article.description = " "
    end


  end

  def set_title(html_doc, url)
    if html_doc.css("meta[property='og:title']").first != nil
        @article.title = html_doc.css("meta[property='og:title']").first.attributes["content"].value
    end
    if @article.title == nil && html_doc.search('title').first
      @article.title = html_doc.search('title').text.strip
    end
    if @article.title == nil && html_doc.search('h1').first
      @article.title = html_doc.search('h1')
    end
    if @article.title == nil
      @article.title = url
    end

  end


  def article_params
    params.require(:article).permit(:category_id, :url)
  end

  def redirect(article)
    category = @article.category_id
    path = "category_path(#{category})"
    redirect_to send(path)

  end

  def set_splash
    @category = Category.new
    if Category.first
      @categories = current_user.categories.order(created_at: :desc)
      @splash = []
      @categories.each do |category|
        @splash << [category.name, category.id]
     end
    end

   def set_article
    @article = Article.new
   end
  end






end
