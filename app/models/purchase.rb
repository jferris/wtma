class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  belongs_to :item

  validates_presence_of :user_id, :store_id, :item_id, :price, :quantity

  named_scope :cheap, {:order => 'purchases.price ASC'}
  named_scope :cheapest_by_item, {
    :group => 'purchases.item_id HAVING purchases.price = (
                 SELECT MIN(s_purchases.price)
                 FROM purchases AS s_purchases
                 WHERE s_purchases.item_id = purchases.item_id)'
  }

  named_scope :latest, { :order => 'purchases.created_at DESC' }

  def item_name
    item.name
  end

  def self.cheapest
    cheap.first
  end
end
