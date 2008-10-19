require File.dirname(__FILE__) + '/../test_helper'

class ItemsControllerTest < ActionController::TestCase
  include ActionView::Helpers::AssetTagHelper

  logged_in_user_context do
    context "GET to index" do
      setup do
        get :index
      end

      should_redirect_to 'purchases_path'
    end
  end

  public_context do
    context "with some Purchases" do
      setup do
        cheap_purchase = Factory(:purchase, :price => 0.25)
        item = cheap_purchase.item
        expensive_purchase = Factory(:purchase, :price => 12.0, :item => item)
      end

      context "GET to index" do
        setup { get :index }

        should_assign_to :purchases
        should_render_with_layout 'logged_out'

        should "set @purchases to the cheapest purchase for that item" do
          assigns(:purchases).each do |purchase|
            item = purchase.item
            assert_equal item.cheapest_purchase, purchase
          end
        end
        
        should_have_map

        should "center the map on the USA" do
          assert_select "script", :text => /map.setCenter\(new GLatLng\(#{USA[:lat]}, #{USA[:long]}\), #{DEFAULT_ZOOM_LEVEL}\)/
        end

        should "put the cheapest Purchase for an Item on the map" do
          assigns(:purchases).each do |purchase|
            assert_select "script", :text => /GLatLng\(#{purchase.store.latitude},#{purchase.store.longitude}\)/
          end
        end
      end
    end
  end
end
