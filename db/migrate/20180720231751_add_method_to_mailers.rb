class AddMethodToMailers < ActiveRecord::Migration[5.1]
  def change
    add_column :mailers, :mailer_method, :text
  end
end
