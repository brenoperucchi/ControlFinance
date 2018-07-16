class RemoveFieldsFromMailers < ActiveRecord::Migration[5.1]
  def change
    remove_column :mailers, :mailer_method, :string
    remove_column :mailers, :method_name, :string
    remove_column :mailers, :url, :string
  end
end
