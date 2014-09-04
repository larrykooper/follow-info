require 'faraday'
require 'twitcon/configurable'
require 'twitcon/core_ext/array'
require 'twitcon/core_ext/enumerable'
require 'twitcon/core_ext/hash'
require 'twitcon/cursor'
require 'twitcon/default'
require 'twitcon/error/forbidden'
require 'twitcon/error/not_found'
require 'twitcon/rate_limit'
require 'twitcon/user'
require 'simple_oauth'
require 'uri'

module Twitcon
  class Client
    include Twitcon::Configurable
    attr_reader :rate_limit
    MAX_USERS_PER_REQUEST = 100

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Twitcon::Client]
    def initialize(options={})
      Twitcon::Configurable.keys.each do |key|
        instance_variable_set("@#{key}", options[key] || Twitcon.instance_variable_get("@#{key}"))
      end
      @rate_limit = Twitcon::RateLimit.new
    end

    # @see https://dev.twitter.com/docs/api/1/get/followers/ids
    # @rate_limited Yes
    # @authentication_required No unless requesting it from a protected user
    # @raise [Twitcon::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitcon::Cursor]
    # @overload follower_ids(options={})
    #   Returns an array of numeric IDs for every user following the authenticated user
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the authenticated user's followers' IDs
    #     Twitcon.follower_ids
    # @overload follower_ids(user, options={})
    #   Returns an array of numeric IDs for every user following the specified user
    #
    #   @param user [Integer, String, Twitcon::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return @sferik's followers' IDs
    #     Twitcon.follower_ids('sferik')
    #     Twitcon.follower_ids(7505382)  # Same as above
    def follower_ids(*args)
      options = {:cursor => -1}
      options.merge!(args.extract_options!)
      user = args.pop
      options.merge_user!(user)
      response = get("/1.1/followers/ids.json", options)
      Twitcon::Cursor.from_response(response)
    end

    # @see https://dev.twitter.com/docs/api/1/get/friends/ids
    # @rate_limited Yes
    # @authentication_required No unless requesting it from a protected user
    # @raise [Twitcon::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitcon::Cursor]
    # @overload friend_ids(options={})
    #   Returns an array of numeric IDs for every user the authenticated user is following
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the authenticated user's friends' IDs
    #     Twitcon.friend_ids
    # @overload friend_ids(user, options={})
    #   Returns an array of numeric IDs for every user the specified user is following
    #
    #   @param user [Integer, String, Twitcon::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return @sferik's friends' IDs
    #     Twitcon.friend_ids('sferik')
    #     Twitcon.friend_ids(7505382)  # Same as above
    def friend_ids(*args)
      options = {:cursor => -1}
      options.merge!(args.extract_options!)
      user = args.pop
      options.merge_user!(user)
      response = get("/1.1/friends/ids.json", options)
      Twitcon::Cursor.from_response(response)
    end

    # Returns extended information for up to 100 users
    #
    # @see https://dev.twitter.com/docs/api/1/get/users/lookup
    # @rate_limited Yes
    # @authentication_required Yes
    # @raise [Twitcon::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitcon::User>] The requested users.
    # @overload users(*users)
    #   @param users [Array<Integer, String, Twitcon::User>, Set<Integer, String, Twitcon::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Return extended information for @sferik and @pengwynn
    #     Twitcon.users('sferik', 'pengwynn')
    #     Twitcon.users(7505382, 14100886)    # Same as above
    # @overload users(*users, options)
    #   @param users [Array<Integer, String, Twitcon::User>, Set<Integer, String, Twitcon::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    def users(*args)
      options = args.extract_options!
      args.flatten.each_slice(MAX_USERS_PER_REQUEST).threaded_map do |users|
        response = post("/1.1/users/lookup.json", options.merge_users(users))
        collection_from_array(response[:body], Twitcon::User)
      end.flatten
    end

    # Returns information about one user
    # https://dev.twitter.com/docs/api/1.1/get/users/show
    def user_show(*args)
      options = args.extract_options!
      response = get("/1.1/users/show.json", options)
    end

      # Perform an HTTP GET request
    def get(path, params={}, options={})
      request(:get, path, params, options)
    end

    # Perform an HTTP POST request
    def post(path, params={}, options={})
      request(:post, path, params, options)
    end

  private

    def collection_from_array(array, klass)
      array.map do |element|
        klass.fetch_or_new(element)
      end
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware))
    end

    # Perform an HTTP request
    def request(method, path, params={}, options={})
      uri = options[:endpoint] || @endpoint
      uri = URI(uri) unless uri.respond_to?(:host)
      uri += path
      #puts "URI: " # debug
      #puts uri # debug
      request_headers = {}
      if self.credentials?
        authorization = auth_header(method, uri, params)
        request_headers[:authorization] = authorization.to_s
      end
      connection.url_prefix = options[:endpoint] || @endpoint
      response = connection.run_request(method.to_sym, path, nil, request_headers) do |request|
        unless params.empty?
          case request.method
          when :post, :put
            request.body = params
          else
            request.params.update(params)
          end
        end
        yield request if block_given?
      end.env
      @rate_limit.update(response[:response_headers])
      response
    rescue Faraday::Error::ClientError
      raise Twitcon::Error::ClientError
    end

    def auth_header(method, uri, params={})
      # When posting a file, don't sign any params
      signature_params = [:post, :put].include?(method.to_sym) && params.values.any?{|value| value.is_a?(File) || (value.is_a?(Hash) && (value[:io].is_a?(IO) || value[:io].is_a?(StringIO)))} ? {} : params
      SimpleOAuth::Header.new(method, uri, signature_params, credentials)
    end

  end # class Client
end