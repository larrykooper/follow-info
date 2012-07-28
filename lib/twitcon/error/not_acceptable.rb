require 'twitcon/error/client_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 406
    class NotAcceptable < Twitcon::Error::ClientError
      HTTP_STATUS_CODE = 406
    end
  end
end
