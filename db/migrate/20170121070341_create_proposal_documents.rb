class CreateProposalDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :proposal_documents do |t|
      t.string :name
      t.string :state
      t.datetime :approved_at
      t.belongs_to :proposal

      t.timestamps
    end
  end
end