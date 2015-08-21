class AddNicknameToCircuits < ActiveRecord::Migration
  def change
    add_column :circuits, :nickname, :string
  end
end
