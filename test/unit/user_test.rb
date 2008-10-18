require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  include Clearance::Test::Unit::UserTest
  
  context "a user" do
    setup { @user = Factory(:user) }
    
    should "have the default first name of Joe" do
      assert_equal "Joe", @user.first_name
    end
  end
end