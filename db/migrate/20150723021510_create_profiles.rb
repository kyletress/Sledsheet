class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :athlete_id
      t.string :favorite_track
      t.string :favorite_curve
      t.string :coach
      t.string :location
      t.string :hometown
      t.string :twitter
      t.string :instagram
      t.string :facebook
      t.string :rallyme
      t.string :sled
      t.text :about

      t.timestamps null: false
    end
  end
end
