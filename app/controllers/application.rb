class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  include HoptoadNotifier::Catcher
  include Clearance::App::Controllers::ApplicationController
end
