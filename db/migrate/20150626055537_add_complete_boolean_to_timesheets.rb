class AddCompleteBooleanToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :complete, :boolean, default: false
  end
end
