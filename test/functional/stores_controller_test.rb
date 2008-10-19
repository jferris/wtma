require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  should_route :get, '/stores', :action => :index
  should_route :get, "/stores/1", :action => :show, :id => 1
  should_route :post, "/stores", :action => :create

  context "with a store" do
    setup { @store = Factory(:store) }

    public_context do
      should_deny_access_on 'get  :index'
      should_deny_access_on "post :create, :name => 'test'"

      context "on GET to show" do
        setup { get :show, :id => @store }

        should_display :store
        should_render_with_layout 'logged_out'
      end
    end

    logged_in_user_context do
      context "no Purchases made by @user" do
        setup do
          Purchase.delete_all(:user_id => @user.id)
        end

        context "GET to index" do
          setup do
            get :index
          end

          should "have a link to purchases_path" do
            assert_select 'p a[href=?]', purchases_path
          end
        end
      end

      context "some Purchases made by @user" do
        setup do
          5.times { Factory(:purchase, :user => @user) }
        end

        context "on GET to index" do
          setup do
            get :index
          end

          should_have_store_map
          should_assign_to :stores

          should "only display 4 stores" do
            assert_select '.store', :count => 4
          end

          should "crown the best store" do
            assert_select 'a', "#{assigns(:stores)[0].name}" do
              assert_select 'span[class=crown]'
            end
          end

          should "have a li for each store" do
            assigns(:stores)[1..-1].each do |store|
              assert_select 'li h3 a', /#{store.name}/
            end
          end
        end
      end

      context "on GET to show" do
        setup { get :show, :id => @store }

        should_display :store
        should_render_with_layout 'application'
      end

      context "on JS POST to create with valid params" do
        setup do
          @latitude  = 42.3971
          @longitude = -71.126
          post :create, :store  => { :name      => "store",
                                     :location  => 'Fairy land',
                                     :latitude  => @latitude,
                                     :longitude => @longitude },
                        :format => :js
        end

        before_should "not verify authenticity" do
          @controller.expects(:verify_authenticity_token).never
        end

        should_change "Store.count", :by => 1

        should "keep the passed latitude" do
          assert_equal @latitude, assigns(:store).latitude
        end

        should "keep the passed longitude" do
          assert_equal @longitude, assigns(:store).longitude
        end

        should "set the store id on the form" do
          assert_select_rjs :replace, :purchase_store_id
        end
      end

      context "on JS POST to create with valid params for an existing Store" do
        setup do
          post :create, :store  => { :name      => @store.name,
                                     :location  => @store.location,
                                     :latitude  => @store.latitude,
                                     :longitude => @store.longitude },
                        :format => :js
        end

        should_not_change 'Store.count'
      end

      context "on JS POST to create with invalid params" do
        setup do
          trap_exception { post :create, :store => {}, :format => :js }
        end

        should_not_change "Store.count"
        should_raise_exception
      end
    end
  end
end
