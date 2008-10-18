class Item < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :purchases, :dependent => :destroy

  def cheapest_purchase
    purchases.cheapest
  end

  def cheapest_purchase_in_stores(stores)
    purchases.in_stores(stores).cheapest
  end

  def cheapest_stores(stores)
    # TODO: this currently could return the same store twice
    purchases.in_stores(stores).cheap.map(&:store)
  end
end
