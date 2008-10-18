require File.dirname(__FILE__) + '/../test_helper'

class PurchaseTest < Test::Unit::TestCase
  context "a Purchase" do
    setup { @purchase = Factory(:purchase) }

    should_belong_to :user
    should_belong_to :store
    should_belong_to :item

    should_require_attributes :user_id, :store_id, :item_id, :price, :quantity

    context "another Purchase" do
      setup { @expensive = Factory(:purchase, :price => @purchase.price+1) }

      should "produce Purchases sorted by price when sent .cheap" do
        cheaps = Purchase.cheap
        purchases = cheaps.sort{|a,b| a.price <=> b.price}
        assert_equal purchases, cheaps
      end

      should "produce the cheapest Purchase when sent .cheapest" do
        purchase = Purchase.first(:order => 'price ASC')
        assert_equal purchase, Purchase.cheapest
      end

      context "with another Purchase for the same Item" do
        setup do
          @item = @purchase.item
          @another = Factory(:purchase, :item => @item, :price => @purchase.price+2)
        end

        should "produce the cheapest Purchase for an Item when sent .cheapest_by_item" do
          cheapests = Purchase.cheapest_by_item
          cheapests.each do |purchase|
            assert_equal purchase.item.cheapest_purchase, purchase
          end
        end
      end
    end
  end
end
