class CreateMailers < ActiveRecord::Migration[5.0]
  def change
    create_table :mailers do |t|
      t.string :method_name
      t.text :parameters
      t.string :url
      t.string :token
      t.belongs_to :store, index:true 
      t.references :userable, :polymorphic => true 
      t.references :mailable, :polymorphic => true
      t.datetime :send_at

      t.timestamps
    end
  end
end
