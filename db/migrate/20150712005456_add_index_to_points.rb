class AddIndexToPoints < ActiveRecord::Migration
  def change
    add_index :points, :season_id
    add_index :points, :timesheet_id
    add_index :points, :athlete_id
    add_index :points, :circuit_id
  end
end
