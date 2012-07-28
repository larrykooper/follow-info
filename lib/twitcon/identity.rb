require 'twitcon/base'

module Twitcon
  class Identity < Base

    def self.fetch(attrs)
      return unless identity_map

      id = attrs[:id]
      if id  && object = identity_map.fetch(id)
        return object.update(attrs)
      end

      return yield if block_given?
      raise Twitcon::IdentityMapKeyError, 'key not found'
    end

    # Stores an object in the identity map.
    #
    # @param attrs [Hash]
    # @return [Twitcon::Identity]
    def self.store(object)
      return object unless identity_map
      identity_map.store(object.id, object)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing an :id key.
    # @return [Twitcon::Identity]
    def initialize(attrs={})
      super
      raise ArgumentError, "argument must have an :id key" unless self.id
    end

    # @param other [Twitcon::Identity]
    # @return [Boolean]
    def ==(other)
      super || self.attr_equal(:id, other) || self.attrs_equal(other)
    end

    # @return [Integer]
    def id
      @attrs[:id]
    end

  end
end
