# -*- ruby -*-
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, :cli => "--fail-fast --color --format doc" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
  watch('lib/iated.rb')  { "spec/" }
end

guard 'cucumber', :cli => "--profile guard" do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  watch('lib/iated.rb')  { "features" }
  #watch(%r{^src/lib/.+$})          { 'features' }
end
