class ItemsController < ApplicationController
  def index
    @purchases = Purchase.cheapest_by_item
    @map = GMap.new('some-cheap-items-on-a-map')
    @map.center_zoom_init(USA,DEFAULT_ZOOM_LEVEL)
  end
end
