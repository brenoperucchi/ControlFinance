class RemoveSendAtToMailers < ActiveRecord::Migration[5.1]
  def change
    remove_column :mailers, :send_at, :datime
  end
end
