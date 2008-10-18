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

  unless instance_methods.include?('run_with_timing')
    # Times tests if you run with TIMER set
    def run_with_timing(*args, &block)
      @timer = Time.now
      run_without_timing(*args, &block)
      diff = Time.now - @timer
      if diff >= 0.1
        puts "#{diff} - #{self}" 
      end
    end
    alias_method_chain :run, :timing if ENV['TIMER'] 
  end

  include Clearance::Test::TestHelper
end

class ActionController::TestCase
  include ActionView::Helpers::RecordIdentificationHelper
end
