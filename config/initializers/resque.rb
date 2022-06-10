rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

resque_config = YAML.load_file(rails_root + '/config/resque.yml')

if Rails.env.production?
  uri = URI.parse ENV["REDIS_URL"]
  Resque.redis = Redis.new(host: uri.host, port: uri.port,
                           password: uri.password)
else
  Resque.redis = "localhost:6379"
end

#Resque.redis = resque_config[rails_env]  # problem
Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds