class Test::Unit::TestCase
  def self.should_display(collection_or_item, &block)
    item_type = collection_or_item.to_s.singularize

    should "display an element for each #{item_type}" do
      result = if @controller.respond_to?(collection_or_item)
                 @controller.send(collection_or_item)
               else
                 assigns(collection_or_item)
               end

      assert_not_nil result,
                     "#{collection_or_item} was not assigned"

      collection = [result].flatten
      assert collection.size >= 1,
             "Need at least one #{item_type}"

      collection.each do |item|
        assert_select "##{dom_id(item)}" do
          block.bind(self).call(item) if block
        end
      end
    end
  end
end
