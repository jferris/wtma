class Test::Unit::TestCase
  def self.should_autocomplete_for(obj,field)
    underscored = "#{obj}_#{field}"
    should "autocomplete #{obj} #{field}" do
      assert_match %r{new Ajax.Autocompleter\(.*'#{underscored}',.*'#{underscored}_auto_complete',.*'/purchases/autocomplete_#{underscored}',.*\{method: 'get'\}\)}m,
        @response.body
    end
  end
end
