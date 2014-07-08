class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.string :name
      t.string :nickname
      t.integer :track_id
      t.integer :circuit_id
      t.datetime :date

      t.timestamps
    end
  end
end
