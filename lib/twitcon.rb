require 'twitcon/client'
require 'twitcon/configurable'

module Twitcon
  class << self
     include Twitcon::Configurable

    # Delegate to a Twitcon::Client
    #
    # @return [Twitcon::Client]
    def client
      if @client && @client.cache_key == options.hash
        @client
      else
        @client = Twitcon::Client.new(options)
      end
    end

    def respond_to?(method, include_private=false)
      self.client.respond_to?(method, include_private) || super
    end

  private

    def method_missing(method, *args, &block)
      return super unless self.client.respond_to?(method)
      self.client.send(method, *args, &block)
    end

  end
end

Twitcon.setup