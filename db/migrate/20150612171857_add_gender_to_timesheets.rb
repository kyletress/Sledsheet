class AddGenderToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :gender, :integer, default: 0
  end
end
