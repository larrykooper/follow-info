require 'faraday'
require 'twitcon/configurable'
require 'twitcon/identity_map'
require 'twitcon/request/multipart_with_file'  
require 'twitcon/response/parse_json'
require 'twitcon/response/raise_client_error'
require 'twitcon/response/raise_server_error'
require 'twitcon/version'

module Twitcon
  module Default
    ENDPOINT = 'https://api.twitter.com' unless defined? ENDPOINT
    MEDIA_ENDPOINT = 'https://upload.twitter.com' unless defined? MEDIA_ENDPOINT
    SEARCH_ENDPOINT = 'https://search.twitter.com' unless defined? SEARCH_ENDPOINT
    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/json',
        :user_agent => "Twitter Ruby Gem #{Twitcon::Version}"
      },
      :open_timeout => 5,
      :raw => true,
      :ssl => {:verify => false},
      :timeout => 10,
    } unless defined? CONNECTION_OPTIONS
    IDENTITY_MAP = Twitcon::IdentityMap unless defined? IDENTITY_MAP
    MIDDLEWARE = Faraday::Builder.new(
      &Proc.new do |builder|
        builder.use Twitcon::Request::MultipartWithFile # Convert file uploads to Faraday::UploadIO objects
        builder.use Faraday::Request::Multipart         # Checks for files in the payload
        builder.use Faraday::Request::UrlEncoded        # Convert request params as "www-form-urlencoded"
        builder.use Twitcon::Response::RaiseClientError # Handle 4xx server responses
        builder.use Twitcon::Response::ParseJson        # Parse JSON response bodies using MultiJson
        builder.use Twitcon::Response::RaiseServerError # Handle 5xx server responses
        builder.adapter Faraday.default_adapter         # Set Faraday's HTTP adapter
      end
    )

    class << self

      # @return [Hash]
      def options
        Hash[Twitcon::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # @return [String]
      def consumer_key
        ENV['TWITTER_CONSUMER_KEY']
      end

      # @return [String]
      def consumer_secret
        ENV['TWITTER_CONSUMER_SECRET']
      end

      # @return [String]
      def oauth_token
        ENV['TWITTER_OAUTH_TOKEN']
      end

      # @return [String]
      def oauth_token_secret
        ENV['TWITTER_OAUTH_TOKEN_SECRET']
      end

      # @note This is configurable in case you want to use HTTP instead of HTTPS or use a Twitter-compatible endpoint.
      # @see http://status.net/wiki/Twitter-compatible_API
      # @see http://en.blog.wordpress.com/2009/12/12/twitter-api/
      # @see http://staff.tumblr.com/post/287703110/api
      # @see http://developer.typepad.com/typepad-twitter-api/twitter-api.html
      # @return [String]
      def endpoint
        ENDPOINT
      end

      # @return [String]
      def media_endpoint
        MEDIA_ENDPOINT
      end

      # @return [String]
      def search_endpoint
        SEARCH_ENDPOINT
      end

      # @return [Hash]
      def connection_options
        CONNECTION_OPTIONS
      end

      # @return [Twitcon::IdentityMap]
      def identity_map
        IDENTITY_MAP
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      # @return [Faraday::Builder]
      def middleware
        MIDDLEWARE
      end

    end
  end
end
