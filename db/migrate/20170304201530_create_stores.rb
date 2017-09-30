class CreateStores < ActiveRecord::Migration[5.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.text :settings
      t.datetime :disabled_at
      t.datetime :term_at

      t.timestamps
    end
  end
end
