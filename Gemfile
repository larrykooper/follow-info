
source 'https://rubygems.org'

gem 'rack'
gem "rails", "5.1.6.2"
# The below is to fix a vulnerability
gem 'actionview', ">= 5.1.6.2"

group :assets do
  #gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

gem 'resque-status'
gem 'resque'
gem 'devise'
gem 'hpricot'
gem 'jquery-rails', '>= 1.0.3'
gem 'libxml-ruby'
gem 'pg', '~> 0.18'
gem 'dalli'
gem 'thin'
gem 'faraday'
gem 'multi_json'
gem 'simple_oauth'
gem 'addressable'
gem 'memoizable'
gem 'naught'
gem 'http'
gem 'equalizer'
gem 'buftok'
gem 'redis'
# 2019-1216 puma updated due to a vulnerability
gem 'puma', ">= 3.12.2"
gem 'rake', '12.3.3'
# sprockets is a dependency of the rails asset pipeline
gem 'sprockets', ">= 3.7.2"
# sinatra is only included here because it is a dependency of resque
# resque comes with a Sinatra app for monitoring your jobs
gem 'sinatra', ">= 2.0.2"

group :test do
  gem 'mocha'
end

group :development do
  gem 'rspec-rails'
  gem 'byebug'
  gem 'pry'
  #gem 'ruby-debug19', "0.11.6"
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
end

ruby "2.6.5"