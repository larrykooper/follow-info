# The commented lines below are for Redis without RedisToGo
#uri = URI.parse("redis://localhost:6379/")  
#Resque.redis = "localhost:6379"

ENV["REDISTOGO_URL"] ||= 'redis://localhost:6379' 

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port) 

require 'resque/job_with_status'

Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }