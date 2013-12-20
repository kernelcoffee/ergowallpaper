class FavoritesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @wallpapers = current_user.wallpapers.joins(:favorites).page(params[:page])
  end

  def create
    @favorite = current_user.favorites.create(favorites_params)
    @wallpaper = Wallpaper.find(@favorite.wallpaper_id)

    respond_to do |format|
      format.html {render :layout => false}
      format.js
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @wallpaper = Wallpaper.find(@favorite.wallpaper_id)
    @favorite.destroy
    respond_to do |format|
      format.html {render :layout => false}
      format.js
    end
  end

private
  
  def favorites_params
    params.require(:favorite).permit(:wallpaper_id)
  end
end
