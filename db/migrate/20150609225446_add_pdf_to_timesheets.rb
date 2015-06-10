class AddPdfToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :pdf, :string
  end
end
