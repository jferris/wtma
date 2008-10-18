class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :location
      t.float  :latitude
      t.float  :longitude
      t.string :zip
      t.string :street 
      t.string :city
      t.string :state
      t.string :first_name

      t.string   :email
      t.string   :crypted_password, :limit => 40
      t.string   :salt, :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.boolean  :confirmed, :default => false, :null => false
    end

    add_index :users, [:latitude, :longitude]

    add_index :users, :email
    add_index :users, [:id, :salt]
    add_index :users, :remember_token
  end

  def self.down
    remove_index :users, :column => :remember_token
    remove_index :users, :column => [:id, :salt]
    remove_index :users, :column => :email
    remove_index :users, :column => [:latitude, :longitude]

    drop_table(:users)
  end
end
