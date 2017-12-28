class AddAccessorsToBroker < ActiveRecord::Migration[5.1]
  def change
    add_column :brokers, :serializes, :text
  end
end
