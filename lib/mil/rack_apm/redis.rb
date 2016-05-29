module Mil
  module RackApm
    class Redis

      attr_reader :redis
      def initialize(redis)
        @redis = redis
      end

      class << self

        def create(redis)
         @@redis = self.new redis
        end

        def get
          if @@redis.nil?
            raise 'redis is initialize'
          end
          @@redis.redis
        end

      end
    end
  end
end