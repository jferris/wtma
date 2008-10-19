require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  include Clearance::Test::Functional::SessionsControllerTest

  context "GET to new" do
    setup do
      get :new
    end

    should_render_with_layout 'logged_out'
  end
end
