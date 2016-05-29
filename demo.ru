#!/usr/bin/env ruby
# require "rubygems"
#
# class Decorator
#
#   def initialize(app)
#     @app = app
#   end
#
#   def call(env)
#     status, headers, body = @app.call(env)
#     new_body = "=========header==========<br />"
#     body.each {|str| new_body << str}
#     new_body << "<br />   ============footer============"
#     headers['Content-Length']= new_body.bytesize.to_s
#     headers['Content-Type'] = 'text/html'
#     [status, headers, [new_body]]
#   end
#
# end
require File.expand_path('../lib/mil/rack_apm', __FILE__)
require 'rack/cors'
require 'redis'
redis = Redis.new
Mil::RackApm.redis = redis
use Mil::RackApm::Data
map '/hello' do
  run lambda {|env| [200, {"Content-Type"=>"text/html"}, ["hello"]]}
end

map '/' do
  run lambda {|env| [200, {"Content-Type"=>"text/html"}, ["every"]]}
end





