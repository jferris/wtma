class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name
      t.string :location
      t.float  :latitude
      t.float  :longitude
      t.string :city
      t.string :state
      t.string :zip
      
      t.timestamps
    end
    
    add_index :stores, :name
    add_index :stores, [:latitude, :longitude]
    add_index :stores, :zip
  end

  def self.down
    drop_table :stores
  end
end
