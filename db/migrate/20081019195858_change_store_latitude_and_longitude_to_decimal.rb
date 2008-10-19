class ChangeStoreLatitudeAndLongitudeToDecimal < ActiveRecord::Migration
  def self.up
    change_column :stores, :latitude, :decimal, :precision => 15, :scale => 10
    change_column :stores, :longitude, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    change_column :stores, :longitude, :float
    change_column :stores, :latitude, :float
  end
end
