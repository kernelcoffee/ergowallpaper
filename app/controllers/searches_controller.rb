class SearchesController < ApplicationController
  def index
    resolution = params[:resolution]
    options = params[:options]
    options = {} unless !options.nil?
    @search.portrait = options.include?("portrait")
    @search.reviewed = options.include?("reviewed")
    @search.purity_safe = options.include?("safe") 
    @search.purity_sketchy = options.include?("sketchy")
    if user_signed_in?
      @search.purity_nsfw = options.include?("nsfv")
    end
    @search.geometry = resolution
    @search.keywords = params[:search][:keywords]
    @search.color = params[:search][:color]

    puts @search.inspect
    @wallpapers = search_wallpapers(@search)
    # We save the save for the session
   @wallpapers = @wallpapers.page(params[:page])
  end

  def search_wallpapers(search)
    if search.geometry == 'all' || search.geometry.nil? == true
      wallpapers = Wallpaper.all
    elsif /^\d*x\d*$/.match(search.geometry)
      width = /^(\d*)x(\d*)$/.match(search.geometry)[1]
      height = /^(\d*)x(\d*)$/.match(search.geometry)[2]
      wallpapers = Resolution.find_by(:width => width, :height => height).wallpapers
    else
      redirect_to '/'
    end

      wallpapers = wallpapers.where(:portrait => @search.portrait,
                                    :reviewed => @search.reviewed)

      wallpapers = wallpapers.where(get_purity(search.purity_safe, search.purity_sketchy, search.purity_nsfw))
    return wallpapers
  end

  def get_purity(safe, sketchy, nsfw)
    r = ''
    if safe == true
      r << "PURITY = 1"
      if sketchy || nsfw
        r << " AND "
      end
    end
    if sketchy == true
      r << "PURITY = 2"
      if nsfw
        r << " AND "
      end
    end
    if nsfw == true
      r << "PURITY = 3"
    end

    if (r == '')
      if !user_signed_in?
        r << "PURITY = 1"
      end
    end
    return r
  end
end
