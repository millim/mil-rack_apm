#!/usr/bin/env ruby
require File.expand_path('../lib/mil/rack_apm', __FILE__)
require File.expand_path('../lib/mil/rack_apm/web', __FILE__)

require 'rack'
require 'redis'

redis = Redis.new
Mil::RackApm.redis = redis
use Mil::RackApm::Data

map '/web' do
  run Mil::RackApm::Web.new
end

map '/hello' do
  run lambda {|env| [200, {"Content-Type"=>"text/html"}, ["hello"]]}
end





