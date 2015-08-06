class AddGenderEnumToAthletes < ActiveRecord::Migration
  def change
    add_column :athletes, :gender, :integer, default: 0
  end
end
