require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  
  should_route :get, "/stores/1", :action => :show, :id => 1
  should_route :post, "/stores", :action => :create
  should_route :get, "/items/1/stores", :action => :index, :item_id => 1

  public_context do
    should_deny_access_on "post :create, :name => 'test'"
    should_deny_access_on "get :index, :item_id => 1"
  end
  
  context "with a store" do
    setup { @store = Factory(:store) }
    
    context "on GET to show" do
      setup { get :show, :id => @store }
      
      should_display :store
    end
  end
  
  logged_in_user_context do
    context "on POST to create with valid params" do
      setup do
        post :create, :store => {:name => "store",
                                 :location => "Boston, MA"}
      end
      
      should_change "Store.count", :by => 1
      should_redirect_to "store_path(assigns(:store))"
    end
    
    context "on POST to create with invalid params" do
      setup { post :create, :store => {} }
      
      should_not_change "Store.count"
      should_render_template :new
    end

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
