class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  layout :logged_in_or_out

  include HoptoadNotifier::Catcher
  include Clearance::App::Controllers::ApplicationController

  private

  def logged_in_or_out
    logged_in? ? 'application' : 'logged_out'
  end
end
