class ConfirmationsController < ApplicationController
  include Clearance::App::Controllers::ConfirmationsController

  layout 'logged_out'
end
