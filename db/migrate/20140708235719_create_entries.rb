class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :athlete_id
      t.integer :timesheet_id
      t.integer :position

      t.timestamps
    end
  end
end
