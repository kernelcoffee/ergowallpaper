class WallpapersController < ApplicationController	
    before_filter :authenticate_user!, :except => [:index, :show]

	def index
		@user = current_user
		@wallpapers =  Wallpaper.all.page(params[:page])
	end

	def show
		@wallpaper = Wallpaper.find(params[:id])
	end

	def search
		puts params.inspect
	end
	
	def create
		@wallpaper = current_user.wallpapers.create(wallpaper_params)
	end

	def upload
		@wallpapers = current_user.wallpapers.order("created_at DESC").page(params[:page])
	end

	def edit
	 	@wallpaper = Wallpaper.find(params[:id])
	end

	def update
		@wallpaper = Wallpaper.find(params[:id])
		if @Wallpaper.update(params[:post].permit(:title))
			redirect_to wallpapers_path, notice: "Image was successfully updated."
		else
			render :edit
		end
	end

	def destroy
	  @wallpaper = Wallpaper.find(params[:id])
	  @wallpaper.destroy
	  redirect_to wallpapers_path, notice: "Image was successfully destroyed."
	end

	private

	def wallpaper_params
		params.require(:Wallpaper).permit(:name, :image, :remote_image_url, :belongs_to)
	end

	def post_params
		params.require(:post).permit(:name, :image, :remote_image_url)
	end
end
