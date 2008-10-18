require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  include Clearance::Test::Unit::UserTest
  
  context "an OpenID" do
    setup { @openid_identity = 'http://example.com/' }

    context "an OpenID user" do
      setup { @user = Factory(:user, :openid_identity => @openid_identity) }

      should "produce the User with the specified openid_identity when sent .find_or_create_by_openid" do
        assert_equal @user, User.find_or_create_by_openid(@openid_identity,
                                                          {:nickname => 'Joe',:postcode => '02108'})
      end

      [:email, :password].each do |field|
        should "be valid without an #{field}" do
          @user.update_attribute(field, nil)
          assert @user.valid?
        end
      end
    end

    context "without a matching OpenID user" do
      setup { User.delete_all(:openid_identity => @openid_identity) }

      context "when sent .find_or_create_by_openid" do
        setup do
          @first_name = 'Sarah'
          @zip = '60647'
          @user = User.find_or_create_by_openid(@openid_identity,
                                                {:nickname => @first_name,
                                                 :postcode => @zip})
        end

        should "produce a User when sent .find_or_create_by_openid" do
          assert_kind_of User, @user
        end

        [:openid_identity, :first_name, :zip].each do |field|
          should "set the #{field} of the User" do
            assert_equal instance_variable_get("@#{field}"), @user.send(field)
          end
        end
      end
    end
  end
  
  context "a user" do
    setup { @user = Factory(:user) }

    should "have the default first name of Joe" do
      assert_equal "Joe", @user.first_name
    end
  end
  
end