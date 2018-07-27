class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.text :information
      t.references :proposal
      t.references :unit
      t.references :broker
      t.references :admin
      t.boolean :intern

      t.timestamps
    end
  end
end
