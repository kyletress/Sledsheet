class AddStatusEnumToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :status, :integer, default: 0
  end
end
