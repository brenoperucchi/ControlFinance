class CreateProposals < ActiveRecord::Migration[5.0]
  def change
    create_table :proposals do |t|
      t.string :state
      t.text :information
      t.references :unit, foreign_key: false
      t.belongs_to :broker

      t.date :due_at
      t.date :booked_at
      t.date :accepted_at
      t.timestamps
    end
  end
end