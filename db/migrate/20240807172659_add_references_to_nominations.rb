class AddReferencesToNominations < ActiveRecord::Migration[7.1]
  def change
    add_reference :nominations, :movie, null: false, foreign_key: true
    add_reference :nominations, :category, null: false, foreign_key: true
  end
end
