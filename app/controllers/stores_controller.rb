class StoresController < ApplicationController
  before_filter :authenticate, :except => :show

  def index
    @item   = Item.find(params[:item_id])
    @stores = @item.cheapest_stores(current_user.nearby_stores)
  end
  
  def show
    @store = Store.find params[:id]
  end
  
  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to store_path(@store)
    else
      render :action => :new
    end
  end
end
