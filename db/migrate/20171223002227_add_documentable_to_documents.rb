class AddDocumentableToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_reference :documents, :documentable, polymorphic: true, index: true
  end
end
