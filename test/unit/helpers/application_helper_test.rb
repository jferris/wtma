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

    context "a User with no Purchases" do
      setup do
        Purchase.delete_all(:user_id => @user.id)
      end

      should "produce the empty string when sent #li_for_stores" do
        assert_equal '', li_for_stores
      end
    end

    context "a User with a Purchase" do
      setup do
        Factory(:purchase, :user => @user)
      end

      should "produce an li that links to stores_path when sent #li_for_stores" do
        assert_equal %{<li id="stores-index"><a href="#{stores_path}">Stores</a></li>},
                     li_for_stores
      end
    end
  end
end
