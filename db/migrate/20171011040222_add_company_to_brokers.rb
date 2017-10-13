class AddCompanyToBrokers < ActiveRecord::Migration[5.1]
  def change
    add_column :brokers, :company, :string
  end
end
