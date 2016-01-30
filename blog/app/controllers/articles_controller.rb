class ArticlesController < ApplicationController
	before_action :authenticate_user! ,except: [:index]
	before_action :set_article, except: [:index,:new,:create]
	def index
		@articles=Article.paginate(page: params[:page],per_page:4).all
	end
	def show
		@article.update_visits_count
		@comment=Comment.new
	end
	def new
	 	@article=Article.new
	 	@categories=Category.all
	end
	def edit
	end
	def update
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
			
		end
	end
	def create
		@article =current_user.articles.new(article_params)
		@article.categories =params[:categories]
		if @article.save
		redirect_to @article
		else
		render :new
	    end
	end
	def destroy
		@article.destroy
		redirect_to articles_path
	end
	def validate_user
		redirect_to new_user_session_path, notice: "Necesitas Iniciar Sesión"

	end
	def set_article
		@article=Article.find(params[:id])
	end

	private
	def article_params
		params.require(:article).permit(:title,:body,:cover,:categories,:markup_body)
	end
end