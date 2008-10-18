class PurchasesController < ApplicationController

  before_filter :authenticate

  def index
    @purchases = current_user.purchases.latest
  end

end
