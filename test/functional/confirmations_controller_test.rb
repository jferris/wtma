require File.dirname(__FILE__) + '/../test_helper'

class ConfirmationsControllerTest < ActionController::TestCase
  include Clearance::Test::Functional::ConfirmationsControllerTest

  context "with a User" do
    setup do
      @user = Factory(:user)
    end

    context "GET to new" do
      setup do
        get :new, :user_id => @user.id, :salt => @user.salt
      end

      should_render_with_layout 'logged_out'
    end
  end
end
