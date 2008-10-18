class UsersController < ApplicationController
  include Clearance::App::Controllers::UsersController

  def new
    @user = User.new(params[:user])
    @openid_map = GMap.new('openid_location_map', 'openid_map')
    @openid_map.center_zoom_init(USA, DEFAULT_ZOOM_LEVEL)
    @username_map = GMap.new('username_location_map', 'username_map')
    @username_map.center_zoom_init(USA, DEFAULT_ZOOM_LEVEL)
  end
end
