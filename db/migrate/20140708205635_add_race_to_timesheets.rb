class AddRaceToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :race, :boolean, default: false
  end
end
