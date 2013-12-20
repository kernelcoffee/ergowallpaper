namespace :sidekiq do
  desc "ERGOWALLPAPER | Stop sidekiq"
  task :stop do
    system "bundle exec sidekiqctl stop #{pidfile}"
  end

  desc "ERGOWALLPAPER | Start sidekiq"
  task :start do
    system "nohup bundle exec sidekiq -q similars,default -e #{Rails.env} -P #{pidfile} >> #{Rails.root.join("log", "sidekiq.log")} 2>&1 &"
  end

  desc "ERGOWALLPAPER | Start sidekiq with launchd on Mac OS X"
  task :launchd do
    system "bundle exec sidekiq -q similars,default -e #{Rails.env} -P #{pidfile} >> #{Rails.root.join("log", "sidekiq.log")} 2>&1"
  end

  def pidfile
    Rails.root.join("tmp", "pids", "sidekiq.pid")
  end
end