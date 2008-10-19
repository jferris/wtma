class UsersController < ApplicationController
  include Clearance::App::Controllers::UsersController
  
  before_filter :authenticate, :except => [:new, :create]
  before_filter :ensure_owner, :except => [:new, :create]
  
  def edit
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes(params[:user])
      flash[:info] = "Your account was successfully updated."
      redirect_to edit_user_path(@user)
    else
      render :action => :edit
    end
  end
  
  protected
  
  def ensure_owner
    unless current_user == User.find(params[:id])
      deny_access
    end
  end
end
