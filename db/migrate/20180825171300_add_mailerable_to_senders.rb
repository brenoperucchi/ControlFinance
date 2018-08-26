class AddMailerableToSenders < ActiveRecord::Migration[5.1]
  def change
    add_reference :mailer_senders, :mailerable, polymorphic: true
  end
end
