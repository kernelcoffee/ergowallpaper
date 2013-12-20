class Admin::ResolutionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @resolutions = Resolution.all.joins(:aspect_ratio)
  end

  def new
    @resolution = Resolution.new
    respond_to do |format|
      format.html { redirect_to @resolutions }
      format.js
    end
  end

  def create
    @resolution = Resolution.create(resolution_params)
    puts @resolution.inspect
    respond_to do |format|
      format.html { redirect_to admin_resolutions_path, notice: "Resolution was successfully created." }
      format.js
    end   
  end

  def update
  respond_to do |format|
      format.html { redirect_to admin_resolutions_path, notice: "Resolution was successfully updated." }
      format.js
    end

  end

  def destroy
    @resolution = Resolution.destroy(params[:id])
    @resolution.aspect_ratio.check_last
    respond_to do |format|
      format.html { redirect_to admin_resolutions_path, notice: "Resolution was successfully destroyed." }
      format.js
    end   
  end

  def reset_default
    Resolution.delete_all
    testArray = {}
    testArray['4:3'] = [[1600, 1200], [3200, 2400], [4096, 3072], [6400, 4800]]
    testArray['5:4'] = [[1280, 1024], [2560, 2048], [5120, 4096]]
    testArray['16:9'] = [[1366, 768], [1600, 900], [1920, 1080], [2560, 1440], [3840, 2160], [7680, 4320], [3200, 1800]]
    testArray['16:10'] = [[1280, 800], [1440, 900], [1680, 1050], [1920, 1200], [2560, 1600], [2880, 1800], [3840, 2400], [5120, 3200], [7680, 4800]]
    testArray['DLP'] = [[2048, 1080], [4096, 2160]]
    testArray['25:16'] = [[6400, 4096]]

    testArray.each do |t|
      t[1].each do |r|
        puts r.inspect
        Resolution.create(width: r[0], height: r[1])
      end
    end
    redirect_to action: "index"
  end

private

  def resolution_params
    params.require(:resolution).permit(:width, :height)
  end

end
