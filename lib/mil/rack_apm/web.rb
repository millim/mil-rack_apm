require 'mil/rack_apm/redis'
require 'mil/rack_apm/web_data'
require 'sinatra/base'
require 'erb'
module Mil
  module RackApm
    class Web < Sinatra::Base

      dir = File.dirname(File.expand_path(__FILE__))

      set :views,  "#{dir}/views"

      if respond_to? :public_folder
        set :public_folder, "#{dir}/public"
      else
        set :public, "#{dir}/public"
      end

      helpers do

        include Rack::Utils

        def url_path(*path_parts)
          [ path_prefix, path_parts ].join("/").squeeze('/')
        end
        alias_method :u, :url_path

        def path_prefix
          request.env['SCRIPT_NAME']
        end

        def data
          @data ||= Mil::RackApm::WebData.new
        end

        TR_CSS = { 'GET' => '', 'POST' => 'success', 'PUT' => 'warning', 'DELETE' => 'danger'}
        def tr_css(type)
          TR_CSS[type.upcase]
        end


      end


      get '/' do
        @data = data.default_data
        erb :index
      end

      delete '/delete_key' do
        if data.delete_key params[:key]
          'ok'
        else
          'error'
        end
      end
    end
  end
end