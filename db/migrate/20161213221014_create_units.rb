class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.text :information
      t.decimal :value, :precision => 10, :scale => 2
      t.decimal :size, :precision => 10, :scale => 2
      t.decimal :brokerage, :precision => 10, :scale => 2, default: 5
      t.references :build, foreign_key: true

      t.timestamps
    end
  end
end
