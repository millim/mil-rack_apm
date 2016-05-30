require 'mil/rack_apm/redis'
module Mil
  module RackApm
    class WebData
      def initialize
        @redis = Mil::RackApm::Redis.get
      end



      #[{key: xx, count: 1, times: 23},{key: xx, count: 1, times: 23}]
      def default_data
        keys = @redis.keys 'mili-*'
        count_array = redis_key_count keys
        sort_array =  sort_desc count_array
        data = array_set_data sort_array
        data
      end

      private

      def red
        @redis ||= Mil::RackApm.get
      end

      def redis_key_count(keys)
        count_array = {}
        keys.each do |key|
          count_array.store key,  red.get(key).to_i
        end
        count_array
      end

      def array_set_data(array)
        new_array = []
        array.each do |obj|
          _, request_method, path = obj[0].split '-'
          new_array << {request_method: request_method, path: path, count: obj[1], times: red.get("milt-#{request_method}-#{path}") }
        end
        new_array
      end

      def sort_desc(count_array)
        count_array = count_array.sort{
            |a,b|  b[1]<=>a[1]
        }
        count_array
      end
    end
  end
end