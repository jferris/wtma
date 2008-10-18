class Item < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :purchases, :dependent => :destroy

  def cheapest_purchase
    purchases.cheapest
  end
end
