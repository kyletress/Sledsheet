class AddSlugsToAthletesSeasonsAndTimesheets < ActiveRecord::Migration[5.0]
  def change
    add_column :athletes, :slug, :string
    add_column :seasons, :slug, :string
    add_column :timesheets, :slug, :string

    add_index :athletes, :slug, unique: true
    add_index :seasons, :slug, unique: true
    add_index :timesheets, :slug, unique: true
  end
end
