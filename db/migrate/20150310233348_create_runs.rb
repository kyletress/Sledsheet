class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.integer :entry_id, null: false
      t.integer :start
      t.integer :split2
      t.integer :split3
      t.integer :split4
      t.integer :split5
      t.integer :finish

      t.timestamps
    end
  end
end
