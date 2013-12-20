class Album < ActiveRecord::Base
	belongs_to :user
	has_many :albumAssignments
	has_many :wallpapers, :through => :albumAssignments
end
