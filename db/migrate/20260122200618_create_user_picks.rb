class CreateUserPicks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_picks do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :category, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.integer :year, null: false

      t.timestamps
    end

    add_index :user_picks, [:user_id, :category_id, :year], unique: true
  end
end
