class PasswordsController < ApplicationController
  include Clearance::App::Controllers::PasswordsController

  layout 'logged_out', :only => [:new, :create]
end
