#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"
require "yard/rake/yardoc_task"

RSpec::Core::RakeTask.new
YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end
