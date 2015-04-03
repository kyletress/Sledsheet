class AddSeasonIdToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :season_id, :integer
  end
end
