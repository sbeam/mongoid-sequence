require "bundler/setup"
require "minitest"
require "minitest/autorun"
require "mongoid"
require "mongoid/paranoia"

require File.expand_path("../../lib/mongoid-sequence", __FILE__)

Mongoid.configure do |config|
  config.connect_to "mongoid_sequence_test"
end

Dir["#{File.dirname(__FILE__)}/models/*.rb"].each { |f| require f }

class BaseTest < MiniTest::Test
  def teardown
    Mongoid::Clients.default.database.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
