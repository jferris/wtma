class ItemsController < ApplicationController
  before_filter :redirect_to_purchases, :if => :logged_in?

  def index
    @purchases = Purchase.cheapest_by_item
  end

  private

  def redirect_to_purchases
    redirect_to purchases_path
  end
end
