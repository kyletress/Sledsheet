class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.string :link
      t.integer :athlete_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
