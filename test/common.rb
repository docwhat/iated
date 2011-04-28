require 'pathname'
$: << (Pathname.new(__FILE__).dirname.dirname + 'src' + 'lib').to_s

require 'rspec'
require 'rack/test'
require 'iated'

set :environment, :test

# EOF
