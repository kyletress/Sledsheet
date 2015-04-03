class AddIndexToTimesheetsSeason < ActiveRecord::Migration
  def change
    add_index :timesheets, :season_id
  end
end
