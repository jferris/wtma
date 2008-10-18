require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  include Clearance::Test::Unit::UserTest

  should_be_mappable

  context "a user" do
    setup do
      @user = Factory(:user)
    end

    should_have_many :purchases

    should "have the default first name of Joe" do
      assert_equal "Joe", @user.first_name
    end

    context "with some Purchases" do
      setup do
        [:month,:week,:day,:hour].each do |time_ago|
          Factory(:purchase,
                  :user => @user,
                  :created_at => 1.send(time_ago).ago,
                  :item_name => Factory.next(:item_name))
        end
      end

      context "when sent #recent_items" do
        setup do
          @limit = 2
          @result = @user.recent_items(@limit)
        end

        should "produce Items sorted by recency of Purchase" do
          items = @user.purchases.sort{|a,b|b.created_at <=> a.created_at}.map(&:item).first(2)
          assert_equal items, @result
        end

        should "only produce the passed number of Items" do
          assert_equal @limit, @result.size
        end
      end
    end
  end

  context "a user with several nearby and faraway stores" do
    setup do
      User.any_instance.stubs(:auto_geocode_address)
      Store.any_instance.stubs(:auto_geocode_address)

      @user    = Factory(:user,  :latitude  => 42.355835,
                                 :longitude => -71.061849,
                                 :location  => 'happy place')
      @nearby  = Factory(:store, :latitude  => 42.374513,
                                 :longitude => -71.101946,
                                 :location  => 'happy place')
      @faraway = Factory(:store, :latitude  => 42.223714,
                                 :longitude => -72.509492,
                                 :location  => 'happy place')
    end

    should "find a nearby store" do
      assert_equal [@nearby], @user.nearby_stores
    end
  end
  
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
end
