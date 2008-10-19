require File.dirname(__FILE__) + '/../../test_helper' 
require 'action_view/test_case'

class ApplicationHelperTest < ActionView::TestCase 
  should "should wrap the dollar sign in a span" do
    assert_match /<span class='dollar-sign'>\$<\/span>3.25/, number_to_formatted_currency(3.25)
  end

  context "when sent #autocomplete_field" do
    setup do
      @result = autocomplete_field :purchase, :quantity
    end

    before_should "stick the content in the :javascripts content" do
      expects(:content_for).with(:javascripts).yields
    end

    before_should "stick the content in a JavaScript tag" do
      expects(:javascript_tag).yields
    end

    should "generate the div" do
      assert_match /div.*class="auto_complete".*id="purchase_quantity_autocomplete"/,
                   @result
    end

    should "create an Ajax.Autocompleter" do
      underscored = 'purchase_quantity'
      assert_match %r{new Ajax.Autocompleter\(.*'#{underscored}',.*'#{underscored}_autocomplete',.*'/purchases/autocomplete_#{underscored}',.*\{method: 'get'\}\)}m,
                   @content_for_javascripts
    end
  end

  context "logged in" do
    setup do
      @request = ActionController::TestRequest.new
      @user = Factory(:user)
      @request.session[:user_id] = @user.id
      ApplicationHelperTest.any_instance.stubs(:current_user).returns(@user)
    end

    should "produce the name of the current user when sent #user_name" do
      assert_match @user.first_name, user_name
    end
  end
end
