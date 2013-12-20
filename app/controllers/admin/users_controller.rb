class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
  	@users = User.page(params[:page])
  end

  def show 
  end
end
