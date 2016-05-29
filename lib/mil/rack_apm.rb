require "redis"
require "mil/rack_apm/version"
require "mil/rack_apm/redis"
require "mil/rack_apm/data"

module Mil
  module RackApm
    class << self
      def redis=(redis)
        Redis.create redis
      end

      def set(key, value)
        redis  = Redis.get
        redis.set key, value, ex: 20
      end

    end
  end
end
