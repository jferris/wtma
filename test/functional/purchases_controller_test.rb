require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase

  should_route :get,  '/purchases', :action => :index
  should_route :post, '/purchases', :action => :create
  should_route :delete, '/purchases/1', :action => :destroy, :id => '1'
  should_route :get, '/purchases/autocomplete_purchase_quantity', :action => :autocomplete_purchase_quantity

  public_context do
    should_deny_access_on 'get :index'
  end

  logged_in_user_context do
    context "with at least one purchase" do
      setup do
        @purchases = paginate([Factory(:purchase)])
        @store     = @purchases.last.store

        @user.     stubs(:purchases).returns(@purchases)
        @purchases.stubs(:latest).   returns(@purchases)
        @purchases.stubs(:paginate). returns(@purchases)
      end

      context "on GET to index" do
        setup do
          get :index
        end

        before_should "find the user's purchases" do
          @user.expects(:purchases).with().returns(@purchases)
        end

        before_should "find the latest purchases" do
          @purchases.expects(:latest).with().returns(@purchases)
        end

        before_should "paginate the purchases" do
          @purchases.expects(:paginate).with().returns(@purchases)
        end

        should_eventually "paginate purchases" do
        end

        should_respond_with :success
        should_render_template :index
        should_assign_to :purchases, :equals => '@purchases'
        should_assign_to :new_purchase
        should_autocomplete_for :purchase, :quantity
        #should_autocomplete_for :purchase, :item

        should_display :purchases do |purchase|
          assert_remote_link_to :delete, purchase_path(purchase)
          assert_remote_link_to :get, 
                                purchase_stores_path(purchase)
          assert_select "##{dom_id(purchase, :stores_for)}"
        end
        
        should "have the purchases list" do
          assert_select "#purchases"
        end

        should "have the new purchase form" do
          assert_select "form#new_purchase" <<
                          "[action='#{purchases_path}']" <<
                          "[method='post']"
        end

        %w(item_name quantity price).each do |field|
          should "have a text field to enter the #{field}" do
            assert_select "#new_purchase input" <<
                            "[id='purchase_#{field}']" <<
                            "[name='purchase[#{field}]']" <<
                            "[type='text']"
          end
        end

        should "have a hidden field for a store" do
          assert_select "#new_purchase input" <<
                          "[id='purchase_store_id']" <<
                          "[name='purchase[store_id]']" <<
                          "[type='hidden']"
        end

        should "fill in the name of the latest purchase's store" do
          assert_select '#picked-store-name', @store.name
        end
      end
    end

    context "on GET to index without any previous purchases" do
      setup do
        assert @user.purchases.empty?
        get :index
      end

      should_respond_with :success
      should_not_assign_to :store

      should "have a placeholder for the store name" do
        assert_select '#picked-store-name'
      end
    end

    context "on JS POST to create with valid params" do
      setup do
        @store = Factory(:store)
        post :create, 
             :format => :js,
             :purchase => Factory.attributes_for(:purchase,
                                                 :store_id => @store.id) 
      end

      should_assign_to :purchase, :store
      should_change "@user.purchases.count", :by => 1
      should_assign_to :new_purchase

      should "build a valid purchase" do
        assert_valid assigns(:purchase)
      end

      should "insert the purchase at the top of the list" do
        assert_select_rjs :insert, :top, 'purchases'
      end

      should "assign a new purchase without errors for the view" do
        assert assigns(:new_purchase).errors.empty?
      end

      should "rerender the purchase form" do
        assert_select_rjs :replace, 'new_purchase' do
          assert_select '#purchase_store_id[value=?]', @store.id
        end
      end
    end

    context "on JS POST to create with only a store ID" do
      setup do
        @store = Factory(:store)
        post :create, :format   => :js, 
                      :purchase => { :store_id => @store.to_param }
      end

      should_assign_to :purchase, :store
      should_assign_to :new_purchase
      should_not_change "@user.purchases.count"

      should "rerender the purchase form" do
        assert_select_rjs :replace, 'new_purchase'
      end

      should "not create a new list element" do
        assert_select 'li.purchase', false
      end

      should "assign a new purchase with errors for the view" do
        assert !assigns(:new_purchase).errors.empty?
      end

      should "display errors on purchase form" do
        assert_select "#errorExplanation"
      end
    end

    context "with a purchase owned by the current user" do
      setup do
        @purchase = Factory(:purchase, :user => @user)
      end

      context "on DELETE to destroy" do
        setup do
          delete :destroy, :id => @purchase, :format => :js
        end

        should_change "Purchase.count", :by => -1

        should "remove the purchase from the list" do
          assert_match /new Effect.Fade\("#{dom_id(@purchase)}"/,
                       @response.body
        end
      end
    end

    context "a purchase not owned by the current user" do
      setup do
        @purchase = Factory(:purchase, :user => Factory(:user))
        assert_not_equal @user, @purchase.user
      end

      context "on DELETE to destroy" do
        setup do
          trap_exception do
            delete :destroy, :id => @purchase, :format => :js
          end
        end

        should_not_change "Purchase.count"
        should_raise_exception ActiveRecord::RecordNotFound
      end
    end

    context "on GET to autocomplete_purchase_quantity with a filter" do
      setup do
        @filter = 'c'
        get :autocomplete_purchase_quantity, :purchase => {:quantity => @filter}
      end

      should_assign_to :quantities

      before_should "skip the verify token" do
        @controller.expects(:verify_authenticity_token).never
      end

      should "produce a list of quantities" do
        assert_select 'ul' do
          assert_select 'li'
        end
      end

      should "produce quantities starting with the filter" do
        assert_all assigns(:quantities) do |quantity|
          quantity =~ /^#{@filter}/
        end
      end

      should "not produce quantities which do not begin with the filter" do
        invalid = Quantity.quantities.reject {|quantity| quantity =~ /^#{@filter}/}
        assert_all invalid do |quantity|
          !assigns(:quantities).include?(quantity)
        end
      end
    end
  end
end
