require 'twitcon/error/client_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 400
    class BadRequest < Twitcon::Error::ClientError
      HTTP_STATUS_CODE = 400
    end
  end
end
