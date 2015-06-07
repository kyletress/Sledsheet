class ChangePositionToBibOnEntries < ActiveRecord::Migration
  def change
    rename_column :entries, :position, :bib
  end
end
