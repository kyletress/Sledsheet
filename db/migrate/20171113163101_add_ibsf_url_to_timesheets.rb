class AddIbsfUrlToTimesheets < ActiveRecord::Migration[5.1]
  def change
    add_column :timesheets, :ibsf_url, :string
  end
end
