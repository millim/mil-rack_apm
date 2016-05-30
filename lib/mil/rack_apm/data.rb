module Mil
  module RackApm
    class Data


      def initialize(app, skip_path = [])
        @app = app
        skip_path = [skip_path] if skip_path.class == String
        @skip_path = skip_path
      end

      def call(env)
        start_time = time_now
        status, header, body = @app.call(env)
        begin
          request_time = (time_now - start_time) * 1000
          return status, header, body if skip_path? env['REQUEST_PATH']
          unless env['REQUEST_PATH'] =~ /.*?\.(png|css|jpg|js|ico|jpeg|gif|bmp)$/
            q_path = path_split_to env['REQUEST_PATH']
            i = "mili-#{env['REQUEST_METHOD']}-#{q_path}"
            t = "milt-#{env['REQUEST_METHOD']}-#{q_path}"
            redis.incr i
            redis.incrbyfloat t, ('%0.3f' % request_time)
          end
          [status, header, body]
        rescue => e
          [status, header, body]
        end
      end

      def redis
        @redis ||= Mil::RackApm::Redis.get
        @redis
      end

      def all_key_delete
        keys = redis.keys 'mil?-*'
        redis.del keys
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

      def skip_path?(path)
        return false if @skip_path.empty?
        @skip_path.each do |p|
          return true if path =~ /^#{p}.*/
        end
        false
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