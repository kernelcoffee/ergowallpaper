require 'carrierwave/orm/activerecord'
include Magick

class Wallpaper < ActiveRecord::Base
  belongs_to :user
  belongs_to :resolution
  
  has_many :favorites
  has_many :users, :through => :favorites

  has_many :colorization
  has_many :colorations, :through => :colorization

  has_many :albumAssignments
  has_many :albums, :through => :albumAssignments

  has_many :similitudes
  has_many :similars, :through => :similitudes
  has_many :inverse_similitudes, :class_name => "Similitude", :foreign_key => "similar_id"
  has_many :inverse_similars, :through => :inverse_similitudes, :source => :wallpaper

	mount_uploader :image, ImageUploader

  validates :image,
    :presence => true
  
  after_create :put_in_queue
  before_destroy :remove_similitudes

  SAFE = 1
  SKETCHY = 2
  NSFW = 3
  
  def put_in_queue
    WallpaperWorker.perform_in(2.seconds, self.id)
  end

  def remove_similitudes
    #remove all link on similitude
    similitudes.each { |s| s.destroy }
    inverse_similitudes.each { |s| s.destroy }
  end

  def get_informations
    img = Magick::Image.read(Settings.root_path.to_s + self.image_url).first
    self.format = img.format.to_s
    self.filesize = img.filesize.to_i
    get_resolution(img)
    get_color_palette    
  end

  def get_resolution(img)
    self.resolution = Resolution.find_by(width: img.columns.to_i, height: img.rows.to_i)
    # strait search failed, looking for multi-screens
    if self.resolution.nil? == true
      puts "looking for multi resolution #{Settings.wallpaper_nb_screens}"
      (2..Settings.wallpaper_nb_screens.to_i).each do |i|
        puts "looking for resolution : #{img.columns.to_i / i}x#{img.rows.to_i}"
        r = Resolution.find_by(width: img.columns.to_i / i, height: img.rows.to_i)
        puts r.inspect
        if r.nil? == false && i <= r.multi
          self.multi = i
          self.resolution = r
          puts "found resolution"
          return
        end
      end
    end
    # looking for portrait resolutions
    if self.resolution.nil? == true
      puts "looking for portrait resolution"
      (1..Settings.wallpaper_nb_screens.to_i).each do |i|
        puts "looking for resolution : #{img.rows.to_i / i}x#{img.columns.to_i}"
        r = Resolution.find_by(width: img.rows.to_i / i, height: img.columns.to_i )
        puts r.inspect
        if r.nil? == false &&  i <= r.multi && r.portrait == true
          self.multi = i
          self.portrait = true
          self.resolution = r
          puts "found resolution"
          return
        end
      end
    end 
  end

  def get_color_palette
    miro = Miro::DominantColors.new(Settings.root_path.to_s + self.image_url)
    colors = miro.to_rgb
    hex = miro.to_hex
    colors.each_with_index do |c, index|
      h = hex[index]
      color = Coloration.find_by(:r => c[0].to_i, :g => c[1].to_i, :b => c[2].to_i)
      if color.nil? == true
        color = Coloration.new(:r => c[0].to_i, :g => c[1].to_i, :b => c[2].to_i, :hex => h.to_s)
        color.save
      end
      self.colorization.build(:coloration_id => color.id)
    end
  end

  def get_geometry
    if self.nil? == false
      if self.resolution.nil? == false
        v = self.resolution.get_geometry(self.multi)
      else
        v = ''
      end
    else
      v = ''
    end
    return v
  end

end
