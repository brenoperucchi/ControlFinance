class AddKindToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :kind, :string
  end
end
