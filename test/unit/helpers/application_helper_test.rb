require File.dirname(__FILE__) + '/../../test_helper' 
require 'action_view/test_case'

class ApplicationHelperTest < ActionView::TestCase 
  def setup
    @request = ActionController::TestRequest.new
  end

  should "should wrap the dollar sign in a span" do
    assert_match /<span class='dollar-sign'>\$<\/span>3.25/, number_to_formatted_currency(3.25)
  end

  logged_in_user_context do
    should "produce the name of the current user when sent #user_name" do
      assert_match @user.first_name, user_name
    end
  end
end
