class CreateFinancesTables < ActiveRecord::Migration[5.0]
  def change
    create_table :finances_accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra, default: false

      t.timestamps
    end
    add_index :finances_accounts, [:name, :type]

    create_table :finances_entries do |t|
      t.string :description
      t.date :date
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end
    add_index :finances_entries, :date
    add_index :finances_entries, [:commercial_document_id, :commercial_document_type], :name => "index_entries_on_commercial_doc"

    create_table :finances_amounts do |t|
      t.string :type
      t.references :account
      t.references :entry
      t.decimal :amount, :precision => 20, :scale => 10
    end
    add_index :finances_amounts, :type
    add_index :finances_amounts, [:account_id, :entry_id]
    add_index :finances_amounts, [:entry_id, :account_id]

    create_table :finances_invoices do |t|
      t.references :invoiceable, polymorphic: true
      t.decimal :amount
      t.timestamps
    end
    add_index :finances_invoices, [:invoiceable_id, :invoiceable_type]
  end

  # def self.down
  #   drop_table :finances_accounts
  #   drop_table :finances_entries
  #   drop_table :finances_amounts
  #   drop_table :finances_invoices
  # end
end