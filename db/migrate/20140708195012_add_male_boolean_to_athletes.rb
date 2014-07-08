class AddMaleBooleanToAthletes < ActiveRecord::Migration
  def change
    add_column :athletes, :male, :boolean, default: true
  end
end
