class Purchases::StoresController < ApplicationController
  before_filter :authenticate

  def index
    @purchase = Purchase.find(params[:purchase_id])
    @item     = @purchase.item
    @stores   = @item.cheapest_stores(current_user.nearby_stores)
  end
end
