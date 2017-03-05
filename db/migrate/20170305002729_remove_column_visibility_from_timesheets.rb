class RemoveColumnVisibilityFromTimesheets < ActiveRecord::Migration[5.0]
  def change
    remove_column :timesheets, :visibility
  end
end
