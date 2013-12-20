class AspectRatio < ActiveRecord::Base
	has_many :resolutions

  before_create :set_name

  def set_name
    case self.ratio
    when 1.33
      self.name = "4:3"
    when 1.25
      self.name = "5:4"
    when 1.78
      self.name = "16:9"
    when 1.6
      self.name = "16:10"
    when 1.9
      self.name = "DLP"
    when 1.56
      self.name = "25:16"
    end
  end

  def check_last
    self.destroy unless self.resolutions.count > 0
  end
end
