class ItemsController < ApplicationController
  def index
    @purchases = Purchase.cheapest_by_item
  end
end
