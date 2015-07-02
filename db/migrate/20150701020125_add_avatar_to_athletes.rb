class AddAvatarToAthletes < ActiveRecord::Migration
  def change
    add_column :athletes, :avatar, :string
  end
end
