class ItemsController < ApplicationController
  layout 'logged_out'

  def index
    @purchases = Purchase.cheapest_by_item
  end
end
