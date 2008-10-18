class Test::Unit::TestCase
  def self.should_be_mappable(opts = {})
    model = opts[:model] || self.name.gsub(/Test$/, '').singularize.downcase
    model = model[model.rindex('::')+2..model.size] if model.include?('::')
    context "a #{model}" do
      setup { @item = Factory.build(model.to_sym) }

      should "geocode address on creation" do      
        @item.expects(:auto_geocode_address).returns(:true)
        @item.save
      end
    end
  end
end