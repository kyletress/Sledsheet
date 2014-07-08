class AddIndexesToTimesheets < ActiveRecord::Migration
  def change
    add_index :timesheets, :track_id
    add_index :timesheets, :circuit_id
  end
end
