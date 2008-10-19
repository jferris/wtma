class SessionsController < ApplicationController
  include Clearance::App::Controllers::SessionsController

  layout 'logged_out', :only => [:new]
end
