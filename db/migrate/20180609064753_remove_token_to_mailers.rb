class RemoveTokenToMailers < ActiveRecord::Migration[5.1]
  def change
    remove_column :mailers, :token, :string
  end
end
