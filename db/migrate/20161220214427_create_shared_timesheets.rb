class CreateSharedTimesheets < ActiveRecord::Migration[5.0]
  def change
    create_table :shared_timesheets do |t|
      t.integer :user_id
      t.string :shared_email
      t.integer :shared_user_id
      t.integer :timesheet_id
      t.string :message

      t.timestamps
    end

    add_index :shared_timesheets, :user_id
    add_index :shared_timesheets, :shared_user_id
    add_index :shared_timesheets, :timesheet_id 
  end
end
