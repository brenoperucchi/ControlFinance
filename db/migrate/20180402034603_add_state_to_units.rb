class AddStateToUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :units, :state, :string, default: 'pending'
  end
end
