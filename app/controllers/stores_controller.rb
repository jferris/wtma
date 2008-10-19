class StoresController < ApplicationController
  before_filter :authenticate, :except => :show
  skip_before_filter :verify_authenticity_token

  def index
    @stores = current_user.best_stores.first(4)
  end

  def show
    @store = Store.find params[:id]
  end
  
  def create
    @store = Store.find_or_initialize_by_name_and_location_and_latitude_and_longitude(
      params[:store][:name],
      params[:store][:location],
      params[:store][:latitude],
      params[:store][:longitude])
    @store.save!
  end
end
