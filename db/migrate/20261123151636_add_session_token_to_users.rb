class AddSessionTokenToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :session_token, :string

    User.reset_column_information
    User.find_each { |user| user.update_column(:session_token, SecureRandom.base58(24)) }

    change_column_null :users, :session_token, false
    add_index :users, :session_token, unique: true
  end

  def down
    remove_index :users, :session_token
    remove_column :users, :session_token
  end
end
