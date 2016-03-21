class AddVisibilityToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :visibility, :integer, default: 0 # private
  end
end
