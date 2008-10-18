require File.dirname(__FILE__) + '/../test_helper'

class ItemsControllerTest < ActionController::TestCase
  include ActionView::Helpers::AssetTagHelper

  context "with some Purchases" do
    setup do
      cheap_purchase = Factory(:purchase, :price => 0.25)
      item = cheap_purchase.item
      expensive_purchase = Factory(:purchase, :price => 12.0, :item => item)
    end

    context "GET to index" do
      setup { get :index }

      should_assign_to :purchases
      should_assign_to :map

      should "initialize @map" do
        # Looking at init_begin modifies it.
        assert_not_nil assigns(:map).send(:instance_variable_get,'@init_begin').first
      end

      should "center the map on the USA" do
        assert_match /map.setCenter\(new GLatLng\(#{USA[0]},#{USA[1]}\),#{DEFAULT_ZOOM_LEVEL}\)/,
                     assigns(:map).send(:instance_variable_get, '@init_begin').first.variable
      end

      should "set @purchases to the cheapest purchase for that item" do
        assigns(:purchases).each do |purchase|
          item = purchase.item
          assert_equal item.cheapest_purchase, purchase
        end
      end

      should "output the GMap headers" do
        assert_match /ym4r-gm.js/, @response.body
      end

      should "output the GMap JavaScript" do
        assert_select 'script', /if \(GBrowserIsCompatible\(\)\)/
      end

      should "have the div for the map" do
        assert_select 'div[id=?]', assigns(:map).container
      end
    end
  end
end
