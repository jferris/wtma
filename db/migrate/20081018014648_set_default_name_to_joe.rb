class SetDefaultNameToJoe < ActiveRecord::Migration
  def self.up
    change_column_default :users, :first_name, "Joe"
  end

  def self.down
    change_column_default :users, :first_name, nil
  end
end
