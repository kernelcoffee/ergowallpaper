class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @settings = Settings.thing_scoped.load
  end

  def edit
    @settings = Settings.thing_scoped.load
    @setting = Settings.thing_scoped.find(params[:id])
  end

  def reset_default
    Settings.all.each do |s|
      Settings.destroy s[0]
    end
    Settings.redis_database = "localhost"
    Settings.root_path = Rails.root.to_s + '/public'
    Settings.wallpaper_path = "uploads/"
    Settings.wallpaper_bktree_path = '/tree/'
    Settings.wallpaper_threshold = 0.85
    Settings.wallpaper_nb_colors = 5
    Settings.wallpaper_nb_screens = 3
    redirect_to action: "index"
  end

  def update
    @setting = Settings.thing_scoped.find(params[:id])
    @setting.value = params[:settings][:value]
    if @setting.save
      redirect_to admin_settings_path, notice: "Saved."
    else
      render "edit"
    end
  end
end
