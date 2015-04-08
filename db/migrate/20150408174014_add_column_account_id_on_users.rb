class AddColumnAccountIdOnUsers < ActiveRecord::Migration
  def change
  	add_column :users, :account_id, :integer, null: true
  	remove_index :users, :email
  end
end
