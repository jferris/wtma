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

    context "with several purchases with different prices in different stores" do
      setup do
        Factory(:purchase, :item => @item, :price => 1)
        @stores = [Factory(:store), Factory(:store)]
        @stores.each do |store|
          Factory(:purchase, :item  => @item,
                             :store => store,
                             :price => 2 + store.id)
        end

        @cheapest = Factory(:purchase, :item  => @item,
                                       :store => @stores.first,
                                       :price => 2)
      end

      context "finding the cheapest purchase out of a list of stores" do
        setup do
          @result = @item.cheapest_purchase_in_stores(@stores)
        end

        should "return the cheapest purchase from the given stores" do
          assert_equal @cheapest, @result
        end
      end

      context "finding the cheapest stores for an item when sent #cheapest_stores" do
        setup do
          @result = @item.cheapest_stores
        end

        should "produce the Stores ordered by the Purchase's price for the Item" do
          stores = @item.purchases.sort{|a,b| a.price <=> b.price}.map(&:store)
          assert_equal stores, @result
        end
      end
    end
  end
end
