class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :get_globals
  
  private

  def get_globals
    @aspect_ratios = AspectRatio.all
    if  @search.nil? == true
      @search = Search.new
    end
  end

  protected 

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update)  { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end

  def file_to_string(file)
    File.open(file, 'rb') { |f| f.read }
  end
end
