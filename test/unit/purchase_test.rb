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

    should "return nil for item_name on a purchase without an item" do
      @purchase.item = nil
      assert_nil @purchase.item_name
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

  context "looking for purchases in stores" do
    setup do
      @stores = [Factory(:store), Factory(:store)]

      @in_store_purchases = []
      @stores.each do |store|
        2.times do
          @in_store_purchases << Factory(:purchase, :store => store)
        end
      end

      Factory(:purchase) # purchase at another store

      @result = Purchase.in_stores(@stores)
    end

    should "not return any purchases for other stores" do
      assert_all @result do |purchase|
        @stores.include?(purchase.store)
      end
    end

    should "return every purchase for the specified stores" do
      assert_all @in_store_purchases do |purchase|
        @result.include?(purchase)
      end
    end
  end

  context "looking for purchases by quantities" do
    setup do
      @include_quantities = ['1 gallon','6 pack']
      @exclude_quantities = ['1 quart','30 rack']
      @include_quantities.each do |quantity|
        Factory(:purchase, :quantity => quantity)
      end
      @exclude_quantities.each do |quantity|
        Factory(:purchase, :quantity => quantity)
      end

      @result = Purchase.by_quantities(@include_quantities)
    end

    should "not return any Purchase for other quantities" do
      assert_all @result do |purchase|
        @include_quantities.include?(purchase.quantity)
      end
    end
  end

  context "a new Purchase" do
    setup do
      @purchase = Factory.build(:purchase, 
                                :item_name => nil,
                                :user      => Factory(:user),
                                :store     => Factory(:store))
    end

    should "not have an item" do
      assert_nil @purchase.item
    end

    context "being saved with an existing item name" do
      setup do
        @item = Factory(:item)
        @purchase.item_name = @item.name
        @purchase.save
      end

      should "assign the existing item to item" do
        assert_equal @item, @purchase.item
      end

      should "no longer have a new item name" do
        assert !@purchase.item_name_changed?
      end
    end

    context "being saved with a new item name" do
      setup do
        @item_name = "new item"
        assert !Item.exists?(:name => @item_name)
        @purchase.item_name = @item_name
        @purchase.save
      end

      should "successfully save the record" do
        assert_valid @purchase
      end

      should "assign an item with the correct name" do
        assert_not_nil @purchase.item
        assert_equal @item_name, @purchase.item.name
      end

      should "create the matching item" do
        assert Item.exists?(:name => @item_name)
      end

      should "no longer have a new item name" do
        assert !@purchase.item_name_changed?
      end
    end
  end

  should "find the cheapest price for a purchase" do
    purchase = Factory(:purchase)
    stores   = mock('stores')
    cheapest = mock('cheapest-purchase')
    price    = 100.00

    purchase.item.
      expects(:cheapest_purchase_in_stores).
      with(stores).
      returns(cheapest)

    purchase.user.
      expects(:nearby_stores).
      with().
      returns(stores)

    cheapest.
      expects(:price).
      with().
      returns(price)

    assert_equal price, purchase.cheapest_price
  end

  context "with no nearby Stores" do
    setup do
      @purchase = Factory(:purchase)
      stores   = mock('stores')
      price    = 100.00

      @purchase.item.
        expects(:cheapest_purchase_in_stores).
        with(stores).
        returns(nil)

      @purchase.user.
        expects(:nearby_stores).
        with().
        returns(stores)
    end

    should "produce nil when sent #cheapest_price" do
      assert_nil @purchase.cheapest_price
    end
  end
end
