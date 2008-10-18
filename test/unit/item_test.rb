require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
  context "an Item" do
    setup { @item = Factory(:item) }

    should_require_attributes :name
    should_require_unique_attributes :name
  end
end
