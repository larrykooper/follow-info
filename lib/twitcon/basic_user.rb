require 'twitcon/identity'

module Twitcon
  class BasicUser < Twitcon::Identity
    attr_reader :following, :screen_name
    alias following? following
  end
end
