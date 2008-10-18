require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
  context "an Item" do
    setup { @item = Factory(:item) }

    should_require_attributes :name
    should_require_unique_attributes :name
    should_have_many :purchases, :dependent => :destroy

    context "with two Purchases" do
      setup do
        @expensive = Factory(:purchase, :item => @item, :price => 1.20)
        @cheap     = Factory(:purchase, :item => @item, :price => 0.25)
      end

      should "produce the cheapest when sent #cheapest_purchase" do
        assert_equal @cheap, @item.cheapest_purchase
      end
    end
  end
end
