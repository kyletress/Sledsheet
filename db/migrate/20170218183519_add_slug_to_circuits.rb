class AddSlugToCircuits < ActiveRecord::Migration[5.0]
  def change
    add_column :circuits, :slug, :string
    add_index :circuits, :slug, unique: true
  end
end
