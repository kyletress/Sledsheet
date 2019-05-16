class CreateTemporaryTimesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :temporary_timesheets do |t|
      t.text :raw_data
      t.text :clean_data

      t.timestamps
    end
  end
end
