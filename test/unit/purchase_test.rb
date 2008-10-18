require File.dirname(__FILE__) + '/../test_helper'

class PurchaseTest < Test::Unit::TestCase
  context "a Purchase" do
    setup { @purchase = Factory(:purchase) }

    should_belong_to :user
    should_belong_to :store
    should_belong_to :item

    should_require_attributes :user_id, :store_id, :item_id, :price, :quantity

    should "return its item's name for item_name" do
      assert_equal @purchase.item.name, @purchase.item_name
    end

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

  context "looking for the latest purchases of several purchases" do
    setup do
      @purchases = [2, 1, 3].collect do |i|
        Factory(:purchase, :created_at => i.days.ago)
      end
      @result = Purchase.latest
    end

    should "sort purchases by reverse creation time" do
      assert_equal @result.sort {|b, a| a.created_at <=> b.created_at },
                   @result
    end
    
    should "find all purchases" do
      assert_equal @purchases.size, @result.size
    end
  end
end
