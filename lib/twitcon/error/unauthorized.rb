require 'twitcon/error/client_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 401
    class Unauthorized < Twitcon::Error::ClientError
      HTTP_STATUS_CODE = 401
    end
  end
end
