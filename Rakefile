require 'rake'
require 'rspec/core/rake_task'

task :default => :rspec

desc "Run RSpec code examples"
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.skip_bundler = true
end

desc "Run RSpec code examples with RCov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.skip_bundler = true
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec,/gems/,jsignal_internal',
                 '--output', 'target/coverage']
end
