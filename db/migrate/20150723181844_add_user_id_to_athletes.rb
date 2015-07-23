class AddUserIdToAthletes < ActiveRecord::Migration
  def change
    add_column :athletes, :user_id, :string
    add_index :athletes, :user_id
  end
end
