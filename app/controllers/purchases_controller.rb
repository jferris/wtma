class PurchasesController < ApplicationController

  before_filter :authenticate

  def index
    @purchases = current_user.purchases.latest
    @new_purchase = Purchase.new
  end

  def create
    @purchase = current_user.purchases.build(params[:purchase])
    if @purchase.save
      @new_purchase = Purchase.new
    else
      @new_purchase = @purchase
    end
  end

  def destroy
    @purchase = current_user.purchases.find(params[:id])
    @purchase.destroy
  end

end
