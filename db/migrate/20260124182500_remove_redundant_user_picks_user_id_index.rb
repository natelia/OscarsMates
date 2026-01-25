class RemoveRedundantUserPicksUserIdIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :user_picks, :user_id, if_exists: true
  end
end
