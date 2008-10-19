class SessionsController < ApplicationController
  include Clearance::App::Controllers::SessionsController

  def url_after_create
    purchases_path
  end
end
