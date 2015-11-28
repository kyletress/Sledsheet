class AddRunsCountToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :runs_count, :integer, default: 0, null: false
    ids = Set.new
    Run.all.each {|r| ids << r.entry_id }
    ids.each do |entry_id|
      Entry.reset_counters(entry_id, :runs)
    end
  end

  def self.down
    remove_column :entries, :runs_count
  end
end
