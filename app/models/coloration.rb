class Coloration < ActiveRecord::Base
  has_many :colorizations
  has_many :wallpapers, :through => :colorization
end
