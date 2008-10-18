require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  include Clearance::Test::Functional::UsersControllerTest

  context "GET to new" do
    setup do
      get :new
    end

    should "output the GMap headers" do
      assert_match /ym4r-gm.js/, @response.body
    end

    should "output the GMap JavaScript" do
      assert_select 'script', /if \(GBrowserIsCompatible\(\)\)/
    end

    should "not put the map initialization in an onload" do
      assert_no_match /window.onload = addCodeToFunction\(window.onload,function/, @response.body
    end

    [:openid, :username].each do |map|
      should_assign_to "#{map}_map".to_sym

      should "initialize @#{map}_map" do
        # Looking at init_begin modifies it.
        assert_not_nil assigns("#{map}_map".to_sym).
          send(:instance_variable_get,'@init_begin').first
      end

      should "have the div for #{map}_map" do
        assert_select 'div[id=?]', assigns("#{map}_map".to_sym).container
      end

      should "observe the #{map}_map location field" do
        assert_match /new Form.Element.DelayedObserver\('#{map}_user_location'/,
                     @response.body
      end
    end
  end
end
