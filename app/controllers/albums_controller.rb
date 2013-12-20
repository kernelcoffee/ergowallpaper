class AlbumsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @albums = current_user.albums.to_a
  end
  
  def show
    @albums = current_user.albums.to_a
    @album = current_user.albums.find(params[:id])
    @wallpapers = @album.wallpapers.page(params[:page])
  end

  def new
    @albums = current_user.albums.to_a
    @album = current_user.albums.new
  end

  def add
    @album = current_user.albums.find(params[:id])
    wallpaper = Wallpaper.find(params[:wallpaper_id])
    @assign = @album.albumAssignments.find_by(:wallpaper_id => wallpaper.id)
    if @assign.nil? == true
      @assign = @album.albumAssignments.create(:wallpaper => wallpaper)
    end
  end

  def create
    @album = current_user.albums.create(album_params)
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.js
    end
  end

  def update
    @album = current_user.albums.find(params[:id])
    @album.update_attributes!(album_params)
    respond_to do |format|
      format.html { redirect_to @album }
      format.js
    end
  end

  def remove
    @album = current_user.albums.find(params[:album_id])
    @wallpaper = Wallpaper.find(params[:wallpaper_id])
    @assign = @album.albumAssignments.find_by(:wallpaper_id => @wallpaper.id, :album_id => @album.id)
    @assign.destroy

    respond_to do |format|
      format.html { redirect_to @album }
      format.js
    end

  end

  def destroy
    @album = current_user.albums.find(params[:id])
    @assigns = @album.albumAssignments.destroy_all
    @album.destroy
    
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.js
    end
  end

  private

  def album_params
    params.require(:album).permit(:name, :wallpaper_id)
  end
end
