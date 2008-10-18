class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  belongs_to :item

  validates_presence_of :user_id, :store_id, :item_id, :price, :quantity
end
