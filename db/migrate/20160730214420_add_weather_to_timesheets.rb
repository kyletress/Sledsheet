class AddWeatherToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :weather, :jsonb
  end
end
