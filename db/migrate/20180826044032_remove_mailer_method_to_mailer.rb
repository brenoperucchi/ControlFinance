class RemoveMailerMethodToMailer < ActiveRecord::Migration[5.1]
  def change
    remove_column :mailers, :mailer_method, :text
  end
end
