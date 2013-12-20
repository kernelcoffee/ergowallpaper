# Check the database to see if a entry is missing a file.

class IntegrityWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
	Wallpaper.all.each { |e|  
		logger.info "checking entry " + e.id + " at path " + e.image_url 
	}
  end
end