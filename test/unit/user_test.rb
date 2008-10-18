require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  include Clearance::Test::Unit::UserTest

  should_be_mappable
  
  context "an email User" do
    setup do
      @user = Factory(:user, :openid_identity => nil, :email => 'foo@example.com')
    end

    should_require_attributes :email, :location, :latitude, :longitude
  end
  
  context "an OpenID and location" do
    setup do
      @location = "Boston, MA"
      @openid_identity = 'http://example.com/'
    end

    context "an OpenID user" do
      setup { @user = Factory(:user, :openid_identity => @openid_identity, :email => nil, :location => @location) }

      should_require_attributes :openid_identity

      should "produce the User with the specified openid_identity when sent .find_or_create_by_openid" do
        assert_equal @user, User.find_or_create_by_openid(@openid_identity,
                                                          {'nickname' => 'Joe', 'postcode' => '02108'},
                                                          {:location => @location})
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
                                                {'nickname' => @first_name, 'postcode' => @zip},
                                                {:location => @location})
        end

        should "produce a User when sent .find_or_create_by_openid" do
          assert_kind_of User, @user
        end

        [:openid_identity, :first_name, :zip, :location].each do |field|
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
