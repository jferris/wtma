class Test::Unit::TestCase
  def assert_all(collection, &block)
    assert collection.size >= 1, "Can't test an empty collection"
    unmatched = collection.reject(&block)
    assert unmatched.empty?, unmatched.inspect
  end
end
