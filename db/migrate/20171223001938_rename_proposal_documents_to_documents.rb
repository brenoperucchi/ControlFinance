class RenameProposalDocumentsToDocuments < ActiveRecord::Migration[5.1]
  def change
    rename_table :proposal_documents, :documents
  end
end
