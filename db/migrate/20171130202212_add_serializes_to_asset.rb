class AddSerializesToAsset < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :serializes, :text
  end
end
