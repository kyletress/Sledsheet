class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :athlete_id
      t.integer :timesheet_id
      t.integer :circuit_id
      t.integer :season_id
      t.integer :value

      t.timestamps
    end
  end
end
