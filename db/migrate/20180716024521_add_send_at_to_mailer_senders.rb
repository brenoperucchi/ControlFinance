class AddSendAtToMailerSenders < ActiveRecord::Migration[5.1]
  def change
    add_column :mailer_senders, :send_at, :datetime
  end
end
