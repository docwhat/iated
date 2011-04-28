
require 'rubygems'
require 'sinatra'
require 'iated/ping'
set :run, false

module IATed
  class Application
    def run

      set :server, %w[webrick]
      set :bind, 'localhost'
      set :port, 9494
      set :show_exceptions, true
      set :environment, :development

      Sinatra::Application.run!
    end
  end
end

