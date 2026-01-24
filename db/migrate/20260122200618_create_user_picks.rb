class CreateUserPicks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_picks do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: false
      t.references :category, null: false, foreign_key: { on_delete: :cascade }
      t.references :movie, null: false, foreign_key: { on_delete: :cascade }
      t.integer :year, null: false

      t.timestamps
    end

    add_index :user_picks, [:user_id, :category_id, :year], unique: true
  end
end
