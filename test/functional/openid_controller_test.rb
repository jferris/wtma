require File.dirname(__FILE__) + '/../test_helper'

class OpenidControllerTest < ActionController::TestCase
  def setup
    result = stub('successful_result',:successful? => true)
    @openid_identity = 'http://example.com/'
    @controller.stubs(:authenticate_with_open_id).yields(result, @openid_identity)
  end

  context "successful login" do
    context "a new user" do
      setup do
        User.delete_all(:openid_identity => @openid_identity)
        post :create, :openid_identifier => @openid_identity
      end

      should "create an account"
      should "set the first name"
      should "log the user in"
      should_redirect_to 'new_purchase_path'
    end

    context "an existing user" do
      setup do
        Factory(:user, :openid_identity => @openid_identity)
        post :create, :openid_identifier => @openid_identity
      end

      should "find the correct user"
      should "log the user in"
      should_redirect_to 'new_purchase_path'
    end
  end
end
