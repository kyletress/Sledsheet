class AddTimeZoneToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :time_zone, :string
  end
end
