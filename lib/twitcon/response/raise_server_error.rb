require 'faraday'
require 'twitcon/error/bad_gateway'
require 'twitcon/error/internal_server_error'
require 'twitcon/error/service_unavailable'

module Twitcon
  module Response
    class RaiseServerError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_class = Twitcon::Error::ServerError.errors[status_code]
        raise error_class.from_response(env) if error_class
      end

    end
  end
end
