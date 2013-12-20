class Resolution < ActiveRecord::Base
  has_many :wallpapers
  belongs_to :aspect_ratio

  after_create :calc_ratio

  def calc_ratio
    ratio = self.width.to_f / self.height.to_f
    puts "looking for ratio #{ratio.round(2).to_s}"
    ar = AspectRatio.find_by(:ratio => ratio.round(2).to_f)
    puts ar.inspect
    if ar.nil? == true
      puts "not found create"
      ar = AspectRatio.create(:ratio => ratio.round(2).to_f)
    end
    puts ar.inspect

    self.aspect_ratio = ar
    self.save
    return ar.ratio
  end

  def get_geometry(multi=1)
    "#{(self.width * multi).to_s}x#{self.height.to_s}"
  end
end
