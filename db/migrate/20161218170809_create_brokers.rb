class CreateBrokers < ActiveRecord::Migration[5.0]
  def change
    create_table :brokers do |t|
      t.string :name
      t.belongs_to :store
      t.string :department
      t.string :person_type
      t.boolean :active


      t.timestamps
    end
  end
end
