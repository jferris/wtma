require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase

  should_route :get,  '/purchases', :action => :index
  should_route :post, '/purchases', :action => :create

  public_context do
    should_deny_access_on 'get :index'
  end

  logged_in_user_context do
    context "with at least one purchase" do
      setup do
        @purchases = [Factory(:purchase)]

        @user.     stubs(:purchases).returns(@purchases)
        @purchases.stubs(:latest).   returns(@purchases)
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

        should_eventually "paginate purchases" do
        end

        should_respond_with :success
        should_render_template :index
        should_assign_to :purchases, :equals => '@purchases'
        should_assign_to :new_purchase

        should_display :purchases
        
        should "have the purchases list" do
          assert_select "#purchases"
        end

        should "have the new purchase form" do
          assert_select "form#new_purchase" <<
                          "[action='#{purchases_path}']" <<
                          "[method='post']"
        end

        %w(item_name quantity price).each do |field|
          should "have a text field to enter the item name" do
            assert_select "#new_purchase input" <<
                            "[id='purchase_#{field}']" <<
                            "[name='purchase[#{field}]']" <<
                            "[type='text']"
          end
        end

        should_eventually "have a hidden field for a store" do
          assert_select "#new_purchase input" <<
                          "[id='purchase_store_id']" <<
                          "[name='purchase[store_id]']" <<
                          "[type='hidden']"
        end
      end
    end

    context "on POST to create with valid params" do
      setup do
        @store = Factory(:store)
        post :create, 
             :format => :js,
             :purchase => Factory.attributes_for(:purchase,
                                                 :store_id => @store.id) 
      end

      should_assign_to :purchase
      should_change "@user.purchases.count", :by => 1
      should_assign_to :new_purchase

      should "build a valid purchase" do
        assert_valid assigns(:purchase)
      end

      should "insert the purchase at the top of the list" do
        assert_select_rjs :insert, :top, :purchases
      end

      should "assign a new purchase without errors for the view" do
        assert assigns(:new_purchase).errors.empty?
      end
    end

    context "on POST to create with invalid params" do
      setup { post :create, :format => :js, :purchase => {} }

      should_assign_to :purchase
      should_assign_to :new_purchase
      should_not_change "@user.purchases.count"

      should "rerender the purchase form" do
        assert_select_rjs :replace, :new_purchase
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
  end
end