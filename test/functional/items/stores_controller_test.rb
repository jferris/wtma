require 'test_helper'

class Items::StoresControllerTest < ActionController::TestCase

  should_route :get, "/items/1/stores", :action => :index, :item_id => 1

  public_context do
    should_deny_access_on "get :index, :item_id => 1"
  end

  logged_in_user_context do
    context "with an item" do
      setup do
        @item   = Factory(:item)
        @stores = [Factory(:store), Factory(:store)]

        Item. stubs(:find).           returns(@item)
        @user.stubs(:nearby_stores).  returns(@stores)
        @item.stubs(:cheapest_stores).returns(@stores)
      end

      context "on GET to index" do
        setup do
          get :index, :item_id => @item.to_param
        end

        should_assign_to :stores
        should_display :stores

        before_should "find the item" do
          Item.expects(:find).with(@item.to_param).returns(@item)
        end

        before_should "find the current user's nearby stores" do
          @user.expects(:nearby_stores).with().returns(@stores)
        end

        before_should "find the cheapest stores for the item" do
          @item.expects(:cheapest_stores).with(@stores).returns(@stores)
        end
      end
    end
  end
  
end
