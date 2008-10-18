require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  include Clearance::Test::Functional::UsersControllerTest

  context "GET to new" do
    setup do
      get :new
    end

    [:openid, :username].each do |map|
      should_have_map map
      should_have_map_observer map
    end
  end
end
