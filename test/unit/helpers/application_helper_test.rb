require File.dirname(__FILE__) + '/../../test_helper' 
require 'action_view/test_case'

class ApplicationHelperTest < ActionView::TestCase 
  should "should wrap the dollar sign in a span" do
    assert_match /<span class='dollar-sign'>\$<\/span>3.25/, number_to_formatted_currency(3.25)
  end
end