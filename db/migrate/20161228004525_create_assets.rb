class CreateAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :assets do |t|
      t.string :file
      t.references :assetable, :polymorphic => true
      t.timestamps
    end
  end
end
