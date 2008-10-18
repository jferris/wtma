class CreatePurchase < ActiveRecord::Migration
  def self.up
    create_table :purchases do |t|
      t.references :user
      t.references :store
      t.references :item
      t.float      :price
      t.string     :quantity
    end
  end

  def self.down
    drop_table :purchases
  end
end
