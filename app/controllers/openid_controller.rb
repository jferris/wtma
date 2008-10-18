class OpenidController < ApplicationController
  def create
    redirect_to new_purchase_path
  end
end
