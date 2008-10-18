require File.dirname(__FILE__) + '/../test_helper'

class PurchaseTest < Test::Unit::TestCase
  context "a Purchase" do
    setup { @purchase = Factory(:purchase) }

    should_belong_to :user
    should_belong_to :store
    should_belong_to :item

    should_require_attributes :user_id, :store_id, :item_id, :price, :quantity
  end
end
