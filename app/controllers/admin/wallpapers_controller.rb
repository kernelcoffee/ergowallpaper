class Admin::WallpapersController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end

  def finish_processing
    @unprocessed = Wallpaper.where(:processed => false)
    @unprocessed.each do |u|
      u.put_in_queue
    end
    flash[:notice] = "Unprocessed Wallpapers add to processing queue sucessfully"
    redirect_to '/admin'
  end

  private

end
