class PurchasesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:autocomplete_purchase_quantity]
  before_filter :authenticate
  before_filter :init_google_map, :only => [:index, :create]

  def autocomplete_purchase_quantity
    @quantities = Quantity.filtered(params[:purchase][:quantity])
    render :layout => false, :format => :html
  end

  def index
    @purchases    = current_user.purchases.latest
    @store        = @purchases.first.store unless @purchases.empty?
    @new_purchase = Purchase.new
  end

  def create
    @purchase = current_user.purchases.build(params[:purchase])

    if @purchase.save
      @store        = @purchase.store
      @new_purchase = Purchase.new
    else
      @store        = Store.find_by_id(@purchase.store_id)
      @new_purchase = @purchase
    end
  end

  def destroy
    @purchase = current_user.purchases.find(params[:id])
    @purchase.destroy
  end

  protected

  def init_google_map
    @map = GMap.new('location_map', 'map')
    @map.center_zoom_init(USA, DEFAULT_ZOOM_LEVEL)
  end
end
