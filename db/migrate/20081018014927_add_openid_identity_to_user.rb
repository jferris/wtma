class AddOpenidIdentityToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :openid_identity, :string
    add_index :users, :openid_identity
  end

  def self.down
    remove_index :users, :column => :openid_identity
    remove_column :users, :openid_identity
  end
end
