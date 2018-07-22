class AddOwnerIdToMailers < ActiveRecord::Migration[5.1]
  def change
    add_column :mailers, :owner_id, :integer
  end
end
