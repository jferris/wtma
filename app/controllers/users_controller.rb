class UsersController < ApplicationController
  include Clearance::App::Controllers::UsersController

  def new
    @user = User.new(params[:user])
  end
end
