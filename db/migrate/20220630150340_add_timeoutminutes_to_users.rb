class AddTimeoutminutesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :timeoutminutes, :integer
  end
end
