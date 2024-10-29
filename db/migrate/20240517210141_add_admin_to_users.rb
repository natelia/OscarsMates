class AddAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    
    add_column :users, :admin, :boolean, default: false
  end
end
