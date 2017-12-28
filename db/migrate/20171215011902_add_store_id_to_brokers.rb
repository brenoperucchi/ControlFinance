class AddStoreIdToBrokers < ActiveRecord::Migration[5.1]
  def change
    add_column :brokers, :store_id, :string
  end
end
