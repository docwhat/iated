# -*- ruby -*-
# More info at https://github.com/guard/guard#readme

#guard 'spork' do
#  #watch('config/application.rb')
#  #watch('config/environment.rb')
#  #watch(%r{^config/environments/.+\.rb$})
#  #watch(%r{^config/initializers/.+\.rb$})
#  watch('spec/spec_helper.rb')
#end

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^src/lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
  watch('src/lib/iated.rb')  { "spec/" }
end

guard 'cucumber' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  #watch(%r{^src/lib/.+$})          { 'features' }
end
