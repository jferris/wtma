class Items::StoresController < ApplicationController
  before_filter :authenticate

  def index
    @item   = Item.find(params[:item_id])
    @stores = @item.cheapest_stores(current_user.nearby_stores)
  end
end
