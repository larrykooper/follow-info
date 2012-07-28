require 'twitcon/error/client_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 404
    class NotFound < Twitcon::Error::ClientError
      HTTP_STATUS_CODE = 404
    end
  end
end
