class CreateNotifies < ActiveRecord::Migration[5.1]
  def change
    create_table :notifies do |t|
      t.references :notiable, polymorphic: true
      t.text :settings

      t.timestamps
    end
  end
end
