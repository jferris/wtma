require File.dirname(__FILE__) + '/../test_helper'

class PasswordsControllerTest < ActionController::TestCase
  include Clearance::Test::Functional::PasswordsControllerTest

  context "GET to new" do
    setup do
      get :new
    end

    should_render_with_layout 'logged_out'
  end

  context "POST to create, failed" do
    setup do
      post :create, :password => {:email => ''}
    end

    should_render_template 'new'
    should_render_with_layout 'logged_out'
  end
end
