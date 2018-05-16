class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :url
      t.string :title
      t.string :content
      t.boolean :read
      t.datetime :date
      t.references :category, foreign_key: true
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
