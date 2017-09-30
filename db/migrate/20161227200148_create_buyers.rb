class CreateBuyers < ActiveRecord::Migration[5.0]
  def change
    create_table :buyers do |t|
      t.text :information
      t.belongs_to :store
      t.references :proposal, foreign_key: true 
      t.boolean :active
      
      t.timestamps
    end
  end
end
