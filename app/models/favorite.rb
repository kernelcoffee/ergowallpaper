class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :wallpaper
end
