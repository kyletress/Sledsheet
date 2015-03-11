class AddPositionToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :position, :integer
  end
end
