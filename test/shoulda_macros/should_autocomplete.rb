class Test::Unit::TestCase
  def self.should_autocomplete_for(obj,field)
    underscored = "#{obj}_#{field}"

    should "turn autocomplete off for the #{underscored} input element" do
      assert_select '*[id=?][autocomplete=off]', underscored
    end

    should "autocomplete #{obj} #{field}" do
      assert_match %r{new Ajax.Autocompleter\(.*'#{underscored}',.*'#{underscored}_autocomplete',.*'/purchases/autocomplete_#{underscored}',.*\{method: 'get'\}\)}m,
        @response.body
    end
  end
end
