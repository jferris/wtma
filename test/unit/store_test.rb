require 'test_helper'

class StoreTest < ActiveSupport::TestCase

  context "a store" do
    setup { @store = Factory(:store) }
    
    should_require_attributes :name, :location, :latitude, :longitude
    should_be_mappable
    should_have_many :purchases
  end
  
end
