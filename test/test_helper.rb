ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'quietbacktrace'
require 'factory_girl'
require 'redgreen'
require 'mocha'

class Test::Unit::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  self.backtrace_silencers << :rails_vendor
  self.backtrace_filters   << :rails_root

  include Clearance::Test::TestHelper
end

class ActionController::TestCase
  include ActionView::Helpers::RecordIdentificationHelper
end