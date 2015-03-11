class AddIntermediatesToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :int1, :integer
    add_column :runs, :int2, :integer
    add_column :runs, :int3, :integer
    add_column :runs, :int4, :integer
    add_column :runs, :int5, :integer
  end
end
