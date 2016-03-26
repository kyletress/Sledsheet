class CreateHeats < ActiveRecord::Migration
  def change
    create_table :heats do |t|
      t.references :timesheet, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end

    add_column :runs, :heat_id, :integer

  end
end
