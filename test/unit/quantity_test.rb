require File.dirname(__FILE__) + '/../test_helper'

class QuantityTest < Test::Unit::TestCase
  should "produce a list when sent #quantities" do
    assert_kind_of Array, Quantity.quantities
  end

  context "when sent #filtered" do
    setup do
      @filter = 'c'
      @result = Quantity.filtered(@filter)
    end

    should "produce only quantities starting with the filter string" do
      assert_all @result do |quantity|
        quantity =~ /^#{@filter}/
      end
    end

    should "not produce quantities that do not begin with the filter string" do
      invalid = Quantity.quantities.reject{|quantity| quantity =~ /^#{@filter}/}
      assert_all invalid do |quantity|
        !@result.include?(quantity)
      end
    end
  end
end
