require 'simplecov'
SimpleCov.start

require_relative '../app.rb'

require 'sinatra'
require 'rack/test'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{Dir.pwd}/spec/support/**/*.rb"].each { |f| require f }

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
