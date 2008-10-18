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

      should "set @purchases to the cheapest purchase for that item" do
        assigns(:purchases).each do |purchase|
          item = purchase.item
          assert_equal item.cheapest_purchase, purchase
        end
      end

      should "center the map on the USA" do
        assert_select "script", :text => /map.setCenter\(new GLatLng\(#{USA[:lat]}, #{USA[:long]}\), #{DEFAULT_ZOOM_LEVEL}\)/
      end

      should "output the GMap headers" do
        assert_match /ym4r-gm.js/, @response.body
      end

      should "output the GMap JavaScript" do
        assert_select 'script', /if \(GBrowserIsCompatible\(\)\)/
      end

      should "have the div for the map" do
        assert_select 'div[id=?]', "map"
      end

      should "not put the map initialization in an onload" do
        assert_no_match /window.onload = addCodeToFunction\(window.onload,function/, @response.body
      end

      should "put the cheapest Purchase for an Item on the map" do
        assigns(:purchases).each do |purchase|
          assert_select "script", :text => /GLatLng\(#{purchase.store.latitude},#{purchase.store.longitude}\)/
        end
      end
    end
  end
end
