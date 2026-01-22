class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.date :nomination_date
      t.date :ceremony_date
      t.integer :year, null: false

      t.timestamps
    end

    add_index :settings, :year, unique: true
  end
end
