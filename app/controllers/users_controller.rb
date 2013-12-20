class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @albums = current_user.albums.all
    @users = User.all
  end

  def show
    @albums = current_user.albums.all
    @user = User.find(params[:id])
  end

  def edit 
    @albums = current_user.albums.all
    @user = User.find(params[:id])
  end
end
