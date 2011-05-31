uri = URI.parse("redis://localhost:6379/")  
Resque.redis = Redis.new(:host => uri.host, :port => uri.port,  
                                          :password => uri.password)  
                                          
require 'resque/job_with_status'

Resque::Status.expire_in = (24 * 60 * 60) # 24hrs in seconds                    