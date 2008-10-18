require File.dirname(__FILE__) + '/../test_helper'

class ItemsControllerTest < ActionController::TestCase
  context "with some Purchases" do
    setup do
      cheap_purchase = Factory(:purchase, :price => 0.25)
      item = cheap_purchase.item
      expensive_purchase = Factory(:purchase, :price => 12.0, :item => item)
    end

    context "GET to index" do
      setup { get :index }

      should_assign_to :purchases

      should "set @purchases to the cheapest purchase for that item" do
        assigns(:purchases).each do |purchase|
          item = purchase.item
          assert_equal item.cheapest_purchase, purchase
        end
      end
    end
  end
end
