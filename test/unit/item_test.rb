require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < Test::Unit::TestCase
  should_require_attributes :name
end
