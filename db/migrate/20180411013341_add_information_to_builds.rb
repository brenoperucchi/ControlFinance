class AddInformationToBuilds < ActiveRecord::Migration[5.1]
  def change
    add_column :builds, :information, :text
  end
end
