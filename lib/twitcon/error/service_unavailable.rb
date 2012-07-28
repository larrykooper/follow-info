require 'twitcon/error/server_error'

module Twitcon
  class Error
    # Raised when Twitter returns the HTTP status code 503
    class ServiceUnavailable < Twitcon::Error::ServerError
      HTTP_STATUS_CODE = 503
      MESSAGE = "(__-){ Twitter is over capacity."
    end
  end
end
