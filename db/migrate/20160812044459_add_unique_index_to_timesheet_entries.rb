class AddUniqueIndexToTimesheetEntries < ActiveRecord::Migration
  def change
    add_index :entries, [:timesheet_id, :athlete_id], unique: true
  end
end
