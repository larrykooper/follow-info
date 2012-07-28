require 'faraday'
require 'twitcon/error/bad_request'
require 'twitcon/error/enhance_your_calm'
require 'twitcon/error/forbidden'
require 'twitcon/error/not_acceptable'
require 'twitcon/error/not_found'
require 'twitcon/error/unauthorized'

module Twitcon
  module Response
    class RaiseClientError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_class = Twitcon::Error::ClientError.errors[status_code]
        raise error_class.from_response(env) if error_class
      end

    end
  end
end
