require 'twitcon/error/client_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 403
    class Forbidden < Twitcon::Error::ClientError
      HTTP_STATUS_CODE = 403
    end
  end
end
