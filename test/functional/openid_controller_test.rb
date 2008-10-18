require File.dirname(__FILE__) + '/../test_helper'

class OpenidControllerTest < ActionController::TestCase
  def setup
    @openid_identity = 'http://example.com/'
  end

  context "POST to create" do
    setup do
      @location = 'Boston, MA'
      post :create, {:openid_identifier => @openid_identity, :user => {:location => @location}}
    end

    before_should "not verify authenticity" do
      @controller.expects(:verify_authenticity_token).never
    end

    should "stash the location in the session" do
      assert_equal @location, session[:location]
    end
  end

  context "successful login" do
    setup do
      result = stub('successful_result',:successful? => true)
      @registration = { 'nickname' => 'Francis', 'postcode' => '60647' }
      @controller.stubs(:authenticate_with_open_id).with(nil, :optional => [:nickname, :postcode]).
        yields(result, @openid_identity, @registration)
    end

    context "a new user" do
      setup do
        User.delete_all(:openid_identity => @openid_identity)
        @location = "41 Winter St. Boston, MA 02108"
        @request.session[:location] = @location
        get :create, :openid_identifier => @openid_identity
        @user = User.find_by_openid_identity(@openid_identity)
      end

      should_redirect_to 'new_purchase_path'

      should "create an account" do
        assert_not_nil @user
      end

      should "set the first name" do
        assert_equal @registration['nickname'], @user.first_name
      end

      should "set the zip" do
        assert_equal @registration['postcode'], @user.zip
      end
      
      should "set the location" do
        assert_equal @location, @user.location
      end

      should "log the user in" do
        assert_equal @user.id, session[:user_id]
      end      
    end

    context "an existing user" do
      setup do
        Factory(:user, :openid_identity => @openid_identity)
        get :create, :openid_identifier => @openid_identity
        @user = User.find_by_openid_identity(@openid_identity)
      end

      should_redirect_to 'new_purchase_path'

      should "log the user in" do
        assert_equal @user.id, session[:user_id]
      end
    end
  end
end
