class AddApprovedAtToBrokers < ActiveRecord::Migration[5.1]
  def change
    add_column :brokers, :approved_at, :datetime
  end
end
