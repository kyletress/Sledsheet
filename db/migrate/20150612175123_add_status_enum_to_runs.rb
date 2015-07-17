class AddStatusEnumToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :status, :integer, default: 0
  end
end
