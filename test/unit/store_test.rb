require 'test_helper'

class StoreTest < ActiveSupport::TestCase

  context "a store" do
    setup { @store = Factory(:store) }
    
    should_require_attributes :name, :location, :latitude, :longitude
  end
  
end
