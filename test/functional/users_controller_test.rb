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
      should "initialize the #{map}_map" do
        assert_select "script", :text => /new GMap2\(\$\('#{map}_map'\)\);/
      end

      should "have the div for #{map}_map" do
        assert_select 'div[id=?]', "#{map}_map"
      end

      should "observe the #{map}_map location field" do
        assert_match /new MapObserver\(\{.*observe: *'#{map}_user_location'.*\}\)/m,
                     @response.body
      end
    end
  end
end
