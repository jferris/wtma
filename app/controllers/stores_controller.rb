class StoresController < ApplicationController
  before_filter :authenticate, :except => :show
  
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
