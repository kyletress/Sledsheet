class AddLattitudeAndLongtitudeToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :latitude, :decimal, {precision: 10, scale: 6}
    add_column :tracks, :longitude, :decimal, {precision: 10, scale: 6}
  end
end
