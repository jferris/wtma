class StoresController < ApplicationController
  before_filter :authenticate, :except => :show
  skip_before_filter :verify_authenticity_token

  def index
    @stores = current_user.best_stores
  end

  def show
    @store = Store.find params[:id]
  end
  
  def create
    @store = Store.new(params[:store])
    @store.save!
  end
end
