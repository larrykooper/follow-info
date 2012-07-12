ENV["REDISTOGO_URL"] ||= "redis://larrykooper:326ccce841a2132c4650f75439938cbc@barb.redistogo.com:9012/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }