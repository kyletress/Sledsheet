class AddIndexToEntries < ActiveRecord::Migration
  def change
    add_index :entries, :timesheet_id
    add_index :entries, :athlete_id
  end
end
