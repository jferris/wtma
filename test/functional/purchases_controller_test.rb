require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase

  should_route :get, '/purchases', :action => :index

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

        should_display :purchases
      end
    end
  end
end
