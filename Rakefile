#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"
require "yard/rake/yardoc_task"
require 'cucumber'
require 'cucumber/rake/task'

# Make sure we run tests before build
task :build => [:test]

desc "Runs all tests"
task :test => [:'test:spec', :'test:features']

namespace :test do
  RSpec::Core::RakeTask.new
  Cucumber::Rake::Task.new(:features)
end

YARD::Rake::YardocTask.new(:docs) do |t|
  t.files = ['lib/**/*.rb']
end

# For TravisCI
desc "Run the Travis CI tests"
task :travis => [:build, :doc]

