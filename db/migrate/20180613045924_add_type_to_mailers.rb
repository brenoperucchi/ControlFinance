class AddTypeToMailers < ActiveRecord::Migration[5.1]
  def change
    add_column :mailers, :type, :string
  end
end
