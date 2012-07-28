module Twitcon
  class Version
    MAJOR = 3 unless defined? MAJOR
    MINOR = 3 unless defined? MINOR
    PATCH = 1 unless defined? PATCH
    PRE = nil unless defined? PRE

    class << self

      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

    end

  end
end
