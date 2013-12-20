class Admin::AspectRatiosController < ApplicationController
  def edit
    @aspect_ratio = AspectRatio.find(params[:id])
  end
end
