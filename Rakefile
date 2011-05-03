# -*- ruby -*-

require 'bundler'
Bundler.setup(:default, :development)

require 'rake'
require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'
require 'warbler'

# Verify that we're in jruby. This helped with debugging.
raise "I require JRuby" unless RUBY_ENGINE == "jruby"

TARGET_DIR = "target"
ENV['CI_REPORTS'] = File.join TARGET_DIR, "junit"

# Default task is the coverage report and jar.
task :default => [:rcov, :jar]

# Create the target directory.
task :target_dir do
  Dir.mkdir TARGET_DIR unless File.directory? TARGET_DIR
end

# Create Jar
Warbler::Task.new do |t|
  t.config.jar_name = "target/iated"
end
task :jar => :target_dir

# TODO: Create .exe (windows with launch4j)
# TODO: Create .app (os-x)

# Jenkins
desc "Continuous integration"
task :ci => [:'ci:setup:rspec', :rcov, :jar]

# Testing
desc "Run RSpec code examples"
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.skip_bundler = true # Suggested on some website about jruby.
end

# Coverage
desc "Run RSpec code examples with RCov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.skip_bundler = true # Suggested on some website about jruby.
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,/gems/,jsignal_internal',
                 '--output', 'target/coverage']
end

# Utility: clean
desc "Cleans up the work environment"
task :clean => :'jar:clean' do
  rm_rf TARGET_DIR
end

