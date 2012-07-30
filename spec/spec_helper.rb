require 'rspec'
require 'mongoid'
require 'active_admin/mongoid'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

puts "version: #{Mongoid::VERSION}"

Mongoid.configure do |config|
  Mongoid::VersionSetup.configure config
end

if RUBY_VERSION >= '1.9.2'
  YAML::ENGINE.yamler = 'syck'
end

RSpec.configure do |config|
  # config.mock_with(:mocha)

  config.before(:each) do
    Mongoid.purge!

    # for Mongoid 2.x
    # Mongoid.database.collections.each do |collection|
    #   unless collection.name =~ /^system\./
    #     collection.remove
    #   end
    # end
  end
end