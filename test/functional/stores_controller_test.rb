require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  should_route :get, "/stores/1", :action => :show, :id => 1
  should_route :post, "/stores", :action => :create

  context "with a store" do
    setup { @store = Factory(:store) }

    public_context do
      should_deny_access_on "post :create, :name => 'test'"

      context "on GET to show" do
        setup { get :show, :id => @store }

        should_display :store
        should_render_with_layout 'logged_out'
      end
    end

    logged_in_user_context do
      context "on GET to show" do
        setup { get :show, :id => @store }

        should_display :store
        should_render_with_layout 'application'
      end

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
    end
  end
end
