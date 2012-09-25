
$: << ::File.expand_path('../lib', __FILE__)
require 'iated/server'

run Sinatra::Application
