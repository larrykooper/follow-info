require 'twitcon/error/client_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 420
    class EnhanceYourCalm < Twitcon::Error::ClientError
      HTTP_STATUS_CODE = 420
    end
  end
end