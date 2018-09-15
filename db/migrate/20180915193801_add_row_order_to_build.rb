class AddRowOrderToBuild < ActiveRecord::Migration[5.1]
  def change
    add_column :builds, :row_order, :integer
  end
end
