class AddIndexToSharedTimesheets < ActiveRecord::Migration[5.0]
  def change
    add_index :shared_timesheets, [:timesheet_id, :shared_user_id], unique: true
  end
end
