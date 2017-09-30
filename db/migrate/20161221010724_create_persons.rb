class CreatePersons < ActiveRecord::Migration[5.0]
  def change
    create_table :persons do |t|
      t.string :name
      t.references :store, index: true
      t.string :irs_id
      t.string :department
      t.string :person_type
      t.boolean :active

      t.timestamps
    end
  end
end
