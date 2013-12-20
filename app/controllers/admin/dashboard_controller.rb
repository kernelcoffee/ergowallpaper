class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@users = User.all
  	@wallpapers = Wallpaper.all
  	@unprocessed = Wallpaper.where(:processed => false)
  	@unreviewed = Wallpaper.where(:reviewed => false)
  	@resolutions = Resolution.all
  end
end
