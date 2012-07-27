# This code is only for the "classic" version
uri = URI.parse("redis://localhost:6379/")  
Resque.redis = Redis.new(:host => uri.host, :port => uri.port,  
                                          :password => uri.password)

Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }