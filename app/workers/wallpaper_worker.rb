# Image duplication detection is shamelessly taken from https://github.com/HackerLabs/PhotoOrganizer
# All credits on it goes to Deepak Kandepet / HackerLabs
# http://hackerlabs.org/blog/2012/07/30/organizing-photos-with-duplicate-and-similarity-checking/
# http://hackerlabs.org/
#
# The duplication detection algorithm is based on a hash and a tree
# the tree allows to determine near match images based on the distance
# of the node in that tree.
# To avoid concurency issues one tree and a mutex is created per geometry 

require 'find'
require "fileutils"
require "#{Rails.root}/lib/ergowallpaper/PHash"
require "#{Rails.root}/lib/ergowallpaper/BKTree"

class WallpaperWorker
  include Sidekiq::Worker
  include Sidekiq::Benchmark::Worker
  sidekiq_options :queue => :similars, :retry => 1,
                  :limit => 1

  def initialize
    Miro.options[:color_count] = Settings.wallpaper_nb_colors.to_i
    @tree_path = Settings.root_path.to_s + Settings.wallpapaer_path.to_s + Settings.wallpaper_bktree_path.to_s
    @bktree = BK::Tree.new
    @threshold = Settings.wallpaper_threshold.to_f
  end

  def perform(wallpaper_id)
    logger.info "processing new wallpaper " + wallpaper_id.to_s

    wallpaper = Wallpaper.find_by(:id => wallpaper_id)
    if wallpaper.nil? == true
      logger.info "Wallpaper doesn't exist."
      return
    end
    
    if wallpaper.processed == true
      logger.info "Wallpaper has already been processed."
      return
    end

    wallpaper.get_informations

    if wallpaper.resolution.nil? == true
      logger.info "Wallpaper doesn't match an accpected resolution."  
      wallpaper.destroy
      return
    end

    benchmark.similars do
      s = Redis::Semaphore.new(wallpaper.get_geometry,  :connection => Settings.redis_database)
      if s.lock(90)
        begin
          fingerprint = create_fingerprint(Settings.root_path.to_s + wallpaper.image_url)
          wallpaper.fingerprint = fingerprint.hash.to_s
          logger.info "searching for duplicate in database"
          if get_wallpaper(fingerprint).nil? == false
            logger.info "Found duplicate"
            wallpaper.destroy
          else        # search for similars
            #check if the dest path exist and if there is an asociated bktree
            fingerprint_path = @tree_path.to_s + wallpaper.get_geometry
            logger.info "searching for similars in #{fingerprint_path}"
            FileUtils.mkdir_p fingerprint_path.to_s
            if load_bktree(fingerprint_path.to_s) == false  # check if the tree file exist
              logger.info "#{fingerprint_path} doesn't exist : creating."
              wallpaper.resolution.wallpapers.where(:processed => false).each do |w|
                logger.info "prep for scan"
                scan(w.image_url.to_s)
              end
            end

            logger.info "fingerprints loaded"
            matched_prints = get_matches?(fingerprint, @threshold)
            if matched_prints.size > 0
              logger.info "new entry in database"
            end

            matched_prints.each do |m|
              similar = get_wallpaper(m.first)
              if !similar.nil? && similar.image_url != wallpaper.image_url
                logger.info "found similar in database : " + similar.inspect
                wallpaper.similitudes.build(:similar_id => similar.id)
              else
                logger.info "entry in tree doesn't exist in database"
                logger.info "Tree should be cleaned"
              end
            end

            @bktree.add fingerprint
            save_bktree(fingerprint_path) 
            wallpaper.processed = true
            wallpaper.save
          end #  of search
        rescue => e
          # ignore; do nothing
          FileUtils.rm fingerprint_path + '/fingerprints.data'
          logger.info "error catched : " + e.to_s
        ensure
          logger.info "unlocking Semaphore"
          s.unlock
        end
      end
    end
    benchmark.finish
  end

  #image detection
  def load_bktree(path)
    fingerprints_file = "#{path}#{File::SEPARATOR}fingerprints.data"
    logger.info "loading fingerprint file : #{fingerprints_file}"
    if File.exists? fingerprints_file
     file = File.open(fingerprints_file, 'r')
     @bktree = Marshal.load file.read
     file.close
     logger.info "Existing bktree loaded " + fingerprints_file.to_s
     return true
   else
    return false
  end
end

  def save_bktree(path)
    fingerprints_file = "#{path}#{File::SEPARATOR}fingerprints.data"
    marshal_dump = Marshal.dump(@bktree)
    begin
      file = File.new(fingerprints_file,'w')
      file.write marshal_dump.force_encoding('UTF-8')
      file.close
    rescue Exception => e
      logger.info "Write file failed : " + e.to_s
    end
  end

  def create_fingerprint(file)
    PHash::image_hash(file)
  end

  def get_wallpaper(f)
    Wallpaper.find_by(:fingerprint => f.hash.to_s)
  end

   def get_matches?(hash, threshold)
      #Convert threshold to a distance.
      distance = (1 - threshold) * 64
      #distance = (@threshold) * 64
      matched_prints = @bktree.query(hash, distance.ceil)
      return matched_prints
   end

  # Utilities
  def is_image?(file)
    [".jpg", ".jpeg", ".png"].include? File.extname(file.downcase)
  end

  def scan(path)
    logger.info "scanning file : " + path.to_s
    if is_image?(path)
      image_hash = create_fingerprint(path)
      @bktree.add image_hash
    end
  end
end