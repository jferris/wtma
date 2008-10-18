class ConvertFloatToDecimal < ActiveRecord::Migration
  def self.up
    change_column :purchases, :price, :decimal, :scale     => 2,
                                                :precision => 10
  end

  def self.down
    change_column :purchases, :price, :float
  end
end
