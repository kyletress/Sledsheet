class AddUserIdToTimesheets < ActiveRecord::Migration
  def change
    add_reference :timesheets, :user, index: true, foreign_key: true
  end
end
