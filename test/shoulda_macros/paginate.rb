class Test::Unit::TestCase

  def paginate(collection)
    WillPaginate::Collection.create(1, 10) do |pager|
      pager.replace(collection)
      unless pager.total_entries
        pager.total_entries = collection.size
      end
    end
  end
  
end
