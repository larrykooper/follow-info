require 'twitcon/error'

module Twitcon
  class Error
    # Raised when Twitter returns a 5xx HTTP status code
    class ServerError < Twitcon::Error
      MESSAGE = "Server Error"

      # Create a new error from an HTTP environment
      #
      # @param response [Hash]
      # @return [Twitcon::Error]
      def self.from_response(response={})
        new(nil, response[:response_headers])
      end

      # Initializes a new ServerError object
      #
      # @param message [String]
      # @param response_headers [Hash]
      # @return [Twitcon::Error::ServerError]
      def initialize(message=nil, response_headers={})
        super((message || self.class.const_get(:MESSAGE)), response_headers)
      end

    end
  end
end
