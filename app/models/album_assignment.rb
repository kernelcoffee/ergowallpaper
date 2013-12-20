class AlbumAssignment < ActiveRecord::Base
	belongs_to :wallpaper
  belongs_to :album
end
