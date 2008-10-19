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
          item_name = Factory.next(:item_name)
          2.times do
            Factory(:purchase,
                    :user => @user,
                    :created_at => 1.send(time_ago).ago,
                    :item_name => item_name)
          end
        end
      end

      context "when sent #recent_items" do
        setup do
          @limit = 2
          @result = @user.recent_items(@limit)
        end

        should "produce Items sorted by recency of Purchase" do
          @result.each_with_index do |item, index|
            next if index.zero?
            newest_purchase_for_item = @user.purchases.select do |purchase|
              purchase.item == item
            end.sort do |a,b|
              b.created_at <=> a.created_at
            end.first
            newest_purchase_for_prior_item = @user.purchases.select do |purchase|
              purchase.item == @result[index-1]
            end.sort do |a,b|
              b.created_at <=> a.created_at
            end.first
            assert newest_purchase_for_item.created_at <= newest_purchase_for_prior_item.created_at,
              "#{newest_purchase_for_item.inspect} newer than #{newest_purchase_for_prior_item.inspect}"
          end
        end

        should "only produce the passed number of Items" do
          assert_equal @limit, @result.size
        end

        should "only return unique results" do
          assert_equal @result.uniq, @result
        end
      end

      context "with some Purchases by other Users, some cheaper, some more expensive" do
        setup do
          item = @user.purchases.first.item
          Factory(:purchase, :price => 0.25,  :item_name => item.name)
          Factory(:purchase, :price => 1000.0, :item_name => item.name)
        end

        context "when sent #best_stores" do
          setup do
            @result = @user.best_stores
          end

          should "produce Stores ordered by which is the cheapest for recent_items" do
            items = @user.recent_items(10)
            item_stores = {}
            items.each do |item|
              item_stores[item] = item.purchases.sort {|a,b|a.price <=> b.price}.map(&:store)
            end
            store_rankings = {}
            item_stores.each do |item,stores|
              stores.each_with_index do |store,index|
                store_rankings[store] ||= 0
                store_rankings[store] += stores.size-index
              end
            end
            ranked_stores = store_rankings.sort {|a,b| b[1] <=> a[1]}.map {|store,rank| store}
            assert_equal ranked_stores, @result
          end

          should_eventually "care about the quantity"
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
