class AddIndexToRuns < ActiveRecord::Migration
  def change
    add_index :runs, :entry_id
  end
end
