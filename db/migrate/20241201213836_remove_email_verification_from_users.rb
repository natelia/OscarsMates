class RemoveEmailVerificationFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :pin, :integer
    remove_column :users, :verified, :boolean
  end
end
