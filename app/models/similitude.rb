class Similitude < ActiveRecord::Base
  belongs_to :wallpaper
  belongs_to :similar, :class_name => "Wallpaper"
end
