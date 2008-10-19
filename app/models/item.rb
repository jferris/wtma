class Item < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :purchases, :dependent => :destroy

  named_scope :filtered, lambda {|filter|
    { :conditions => ['name REGEXP ?', "^#{filter}"] }
  }

  def cheapest_purchase
    purchases.cheapest
  end

  def cheapest_purchase_in_stores(stores)
    purchases.in_stores(stores).cheapest
  end

  def cheapest_stores(stores, quantities)
    purchases.by_quantities(quantities).in_stores(stores).cheap.map(&:store).uniq
  end
end
