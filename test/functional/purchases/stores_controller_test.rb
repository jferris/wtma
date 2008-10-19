require 'test_helper'

class Purchases::StoresControllerTest < ActionController::TestCase

  should_route :get, "/purchases/1/stores", :action => :index, :purchase_id => '1'

  public_context do
    should_deny_access_on "get :index, :purchase_id => 1"
  end

  logged_in_user_context do
    context "with an purchase" do
      setup do
        @purchase = Factory(:purchase)
        @item     = @purchase.item
        @stores   = [Factory(:store), Factory(:store)]

        Purchase. stubs(:find).           returns(@purchase)
        @user.    stubs(:nearby_stores).  returns(@stores)
        @item.    stubs(:cheapest_stores).returns(@stores)
      end

      context "on JS GET to index" do
        setup do
          get :index, :purchase_id => @purchase.to_param, :format => :js
        end
        
        should_assign_to :stores
        should_display :stores

        should "update the list of stores for the purchase" do
          assert_select_rjs :replace_html, dom_id(@purchase, :stores_for)
        end

        before_should "find the purchase" do
          Purchase.expects(:find).with(@purchase.to_param).returns(@purchase)
        end

        before_should "find the current user's nearby stores" do
          @user.expects(:nearby_stores).with().returns(@stores)
        end

        before_should "find the cheapest stores for the purchase's item" do
          @item.expects(:cheapest_stores).with(@stores).returns(@stores)
        end
      end
    end
  end
  
end
