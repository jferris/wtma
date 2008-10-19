require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  include Clearance::Test::Functional::UsersControllerTest

  context "GET to new" do
    setup do
      get :new
    end

    should_render_with_layout 'logged_out'
    should_have_map
    
    [:openid, :username].each do |map|
      should_have_map_observer map
    end
  end

  context "POST to create as a human" do
    setup do
      post :create, :user_type => 'human'
    end

    should "display the human form" do
      assert_select '#new_user[style="display: block;"]'
    end

    should "hide the openid form" do
      assert_select '#openid_form[style="display: none;"]'
    end
  end
  
  context "POST to create using openid" do
    setup do
      post :create, :user_type => 'openid'
    end

    should "hide the human form" do
      assert_select '#new_user[style="display: none;"]'
    end

    should "display the openid form" do
      assert_select '#openid_form[style="display: block;"]'
    end
  end
  
  public_context do
    context "with a user" do
      setup do
        @user = Factory(:user)
      end
      should_deny_access_on "get :edit, :id => @user"
    end
  end
  
  logged_in_user_context do
    context "with another user" do
      setup do
        @another_user = Factory(:user)
      end
      should_deny_access_on "get :edit, :id => @another_user"
      should_deny_access_on "put :update, :id => @another_user, :user => {}"
    end
  end
  
  logged_in_user_context do
    context "on GET to edit" do
      setup do
        get :edit, :id => @user
      end
    
      should_assign_to :user
      should_have_map :user
      
      should "display the email field" do
        assert_select "input#user_email"
      end
      
      should "display the change password fields" do
        assert_select "input#user_password"
        assert_select "input#user_password_confirmation"
      end
      
      should "not display the openid field" do
        assert_select "input#openid_identity", false
      end
    end
    
    context "when the user is an openid user" do
      setup do
        @user.update_attributes!({:openid_identity => "openid.openid_identity.com",
                                  :email => nil})
      end
      
      context "on GET to edit" do
        setup do
          get :edit, :id => @user
        end
      
        should "display the openid_identity field" do
          assert_select "input#user_openid_identity"
        end
      
        should "not display the email field" do
          assert_select "input#user_email", false
        end
      
        should "not display the password fields" do
          assert_select "input#password", false
          assert_select "input#password_confirmation", false
        end
      end
    end
    
    context "on PUT to update with valid params" do
      setup do
        put :update, :id => @user, :user => { :first_name => "Valid Name" }
        @user.reload
      end
      
      should_assign_to :user
      should_set_the_flash_to /successfully/
      should_redirect_to "edit_user_path(@user)"
      should "update the user" do
        assert_equal "Valid Name", @user.first_name
      end
    end
    
    context "on PUT to update with invalid params" do
      setup do
        put :update, :id => @user, :user => { :location => "" }
      end
      
      should_assign_to :user
      should_not_set_the_flash
      should_render_template :edit
      
      should "display errors" do
        assert_select "#errorExplanation"
      end
    end
  end
end
