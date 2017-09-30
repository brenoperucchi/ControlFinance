class AddStoreidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :store_id, :integer, index: true
  end
end
