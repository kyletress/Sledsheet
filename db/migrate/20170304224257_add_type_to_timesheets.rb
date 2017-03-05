class AddTypeToTimesheets < ActiveRecord::Migration[5.0]
  def change
    add_column :timesheets, :type, :string
  end
end
