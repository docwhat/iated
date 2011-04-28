#\ -p 3010

require 'rubygems'

gem 'sinatra', '~> 1.2.3'

require 'sinatra'
require 'iated'


set :run, false # disable built-in sinatra web server
set :environment, :development
#set :base_url, 'http://xxtrial' # custom application option

run Sinatra::Application
# root_dir = File.dirname(__FILE__)
# set :root,  root_dir
# set :app_file, File.join(root_dir, 'iated.rb')
# disable :run
# 
# FileUtils.mkdir_p 'log' unless File.exists?('log')
# log = File.new("log/sinatra.log", "a")
# $stdout.reopen(log)
# $stderr.reopen(log)
#
# run Sinatra::Application
