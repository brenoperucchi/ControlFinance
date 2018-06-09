class CreateMailerSenders < ActiveRecord::Migration[5.1]
  def change
    create_table :mailer_senders do |t|
      t.string :to
      t.string :token
      t.text :information
      t.references :mailer

      t.timestamps
    end
  end
end
