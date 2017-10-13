class AddIrsidToBrokers < ActiveRecord::Migration[5.1]
  def change
    add_column :brokers, :irs_id, :string
  end
end
