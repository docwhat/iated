require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require 'pathname'
  $: << (Pathname.new(__FILE__).dirname.dirname + 'src' + 'lib').to_s

  puts "Runing with #{RUBY_ENGINE}"

  require 'rspec'
  require 'rack/test'
end

Spork.each_run do
  # This code will be run each time you run your specs.
  require 'iated'

  set :environment, :test
  IATed::environment = :test
end
# EOF
