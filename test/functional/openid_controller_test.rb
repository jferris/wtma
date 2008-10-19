require File.dirname(__FILE__) + '/../test_helper'

class OpenidControllerTest < ActionController::TestCase
  def setup
    @openid_identity = 'http://example.com/'
  end

  def self.should_authenticate_with_openid
    before_should "attempt to authenticate with openid" do
      @controller.
        expects(:authenticate_with_open_id).
        with(nil, :optional => [:nickname, :postcode]).
        yields(@result, @openid_identity, @registration)
    end
  end

  context "when authenticating with openid would succeed" do
    setup do
      @result = stub('successful_result',:successful? => true)
      @registration = { 'nickname' => 'Francis', 'postcode' => '60647' }
      @controller.
        stubs(:authenticate_with_open_id).
        yields(@result, @openid_identity, @registration)
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

      should_authenticate_with_openid
    end

    context "authenticating as a first-time user" do
      setup do
        User.delete_all(:openid_identity => @openid_identity)
        @location = "41 Winter St. Boston, MA 02108"
        @request.session[:location] = @location
        get :create, :openid_identifier => @openid_identity
        @user = User.find_by_openid_identity(@openid_identity)
      end

      should_redirect_to 'purchases_path'

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

      should_authenticate_with_openid
    end

    context "authenticating as a pre-existing user" do
      setup do
        Factory(:user, :openid_identity => @openid_identity)
        get :create, :openid_identifier => @openid_identity
        @user = User.find_by_openid_identity(@openid_identity)
      end

      should_redirect_to 'purchases_path'

      should "log the user in" do
        assert_equal @user.id, session[:user_id]
      end

      should_authenticate_with_openid
    end
  end

  context "when authenticating with openid would fail" do
    setup do
      @message = 'no good'
      @result = stub('successful_result', :successful? => false,
                                          :message     => @message)
      @registration = { 'nickname' => 'Francis', 'postcode' => '60647' }
      @controller.
        stubs(:authenticate_with_open_id).
        yields(@result, @openid_identity, @registration)
    end

    context "authenticating" do
      setup do
        get :create, :openid_identifier => @openid_identity
      end

      should_set_the_flash_to 'no good'
      should_redirect_to 'new_session_url'

      should_authenticate_with_openid
    end
  end
end
