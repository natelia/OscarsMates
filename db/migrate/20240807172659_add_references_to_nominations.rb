class AddReferencesToNominations < ActiveRecord::Migration[7.1]
  def change
    create_table :nominations do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
