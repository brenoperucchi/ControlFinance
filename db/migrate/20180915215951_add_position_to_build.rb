class AddPositionToBuild < ActiveRecord::Migration[5.1]
  def change
    add_column :builds, :position, :integer
  end
end
