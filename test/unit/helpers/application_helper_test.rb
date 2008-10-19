require File.dirname(__FILE__) + '/../../test_helper' 
require 'action_view/test_case'

class ApplicationHelperTest < ActionView::TestCase 
  def setup
    @request = ActionController::TestRequest.new
  end

  should "should wrap the dollar sign in a span" do
    assert_match /<span class='dollar-sign'>\$<\/span>3.25/, number_to_formatted_currency(3.25)
  end

  context "logged in" do
    setup do
      @user = Factory(:user)
      @request.session[:user_id] = @user.id
      ApplicationHelperTest.any_instance.stubs(:current_user).returns(@user)
    end

    should "produce the name of the current user when sent #user_name" do
      assert_match @user.first_name, user_name
    end
  end
end
