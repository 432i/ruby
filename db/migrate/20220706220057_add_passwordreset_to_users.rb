class AddPasswordresetToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :passwordreset, :boolean, default: true
  end
end
