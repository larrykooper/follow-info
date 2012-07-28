require 'twitcon/error/server_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 500
    class InternalServerError < Twitcon::Error::ServerError
      HTTP_STATUS_CODE = 500
      MESSAGE = "Something is technically wrong."
    end
  end
end
