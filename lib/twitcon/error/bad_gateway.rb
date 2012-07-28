require 'twitcon/error/server_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 502
    class BadGateway < Twitcon::Error::ServerError
      HTTP_STATUS_CODE = 502
      MESSAGE = "Twitter is down or being upgraded."
    end
  end
end
