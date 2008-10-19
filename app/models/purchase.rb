class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  belongs_to :item

  before_validation :save_item, :if => :item_name_changed?

  validates_presence_of :user_id, :store_id, :item_id, :price, :quantity

  named_scope :cheap, {:order => 'purchases.price ASC'}
  named_scope :cheapest_by_item, {
    :group => 'purchases.item_id HAVING purchases.price = (
                 SELECT MIN(s_purchases.price)
                 FROM purchases AS s_purchases
                 WHERE s_purchases.item_id = purchases.item_id)'
  }

  named_scope :latest, { :order => 'purchases.created_at DESC' }
  named_scope :in_stores, lambda {|stores|
    { :conditions => ['purchases.store_id IN(?)', stores] }
  }

  def item_name
    item.name unless item.nil?
  end

  def item_name=(name)
    @new_item_name = name
  end

  def self.cheapest
    cheap.first
  end

  def item_name_changed?
    !@new_item_name.blank?
  end

  def cheapest_price
    item.
      cheapest_purchase_in_stores(user.nearby_stores).
      price
  end

  protected

  def save_item
    self.item = Item.find_or_create_by_name(@new_item_name)
    @new_item_name = nil
  end
end
