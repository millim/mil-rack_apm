module Mil
  module RackApm
    class Data

      #all url data is in the redis
      # Rack::Builder.new do
      #   redis = Redis.new
      #   use Mil::RackApm::Data, redis
      #   ...
      # end
      #
      def initialize(app)
        @app = app
      end

      def call(env)
        start_time = time_now
        status, header, body = @app.call(env)
        request_time = (time_now - start_time) * 1000

        q_path = path_split_to env['REQUEST_PATH']
        i = "mili-#{env['REQUEST_METHOD']}-#{q_path}"
        t = "milt-#{env['REQUEST_METHOD']}-#{q_path}"
        redis.incr i
        redis.incrbyfloat t, ('%0.3f' % request_time)
        [status, header, body]
      end

      def redis
        @redis ||= Mil::RackApm::Redis.get
        @redis
      end



      private

      if defined?(Process::CLOCK_MONOTONIC)
        def time_now
          Process.clock_gettime(Process::CLOCK_MONOTONIC)
        end
      else
        def time_now
          Time.now.to_f
        end
      end

      def path_split_to(path)
        m = path.split '/'
        m.map! do |t|
          if t.to_i.to_s == t
             t = ':obj'
          elsif t.size > 10
            count = 0
            t.each_char do |c|
              if c.to_i.to_s == c
                count = count.next
              end
            end
            t = ':obj' if  count > 1
          end
          t
        end
        m.join '/'
      end

    end
  end
end