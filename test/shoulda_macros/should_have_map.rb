class Test::Unit::TestCase
  def self.should_have_map(map=nil)
    map_name = map.blank? ? "map" : "#{map}_map"
    should "output the GMap headers" do
      assert_match /ym4r-gm.js/, @response.body
    end

    should "output the GMap JavaScript" do
      assert_select 'script', /if \(GBrowserIsCompatible\(\)\)/
    end

    should "initialize the #{map_name}" do
      assert_select "script", :text => /new GMap2\(\$\('#{map_name}'\)\);/
    end

    should "have the div for #{map_name}" do
      assert_select 'div[id=?]', "#{map_name}"
    end
  end
  
  def self.should_have_map_observer(field)
    should "observe the #{field} location field" do
      assert_match /new MapObserver\(\{.*observe: *'#{field}_user_location'.*\}\)/m,
                   @response.body
    end
  end
end