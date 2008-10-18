class AddTimestamps < ActiveRecord::Migration
  def self.up
    tables.each do |table|
      change_table table do |t|
        t.timestamps
      end
    end
  end

  def self.down
    tables.each do |table|
      remove_column table, :created_at
      remove_column table, :updated_at
    end
  end

  def self.tables
    [:users, :items, :purchases]
  end
end
