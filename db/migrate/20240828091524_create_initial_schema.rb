class CreateInitialSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :podcasts do |t|
      t.string :guid, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.boolean :explicit, null: false
      t.string :category, null: false
      t.string :image_url, null: false
      t.string :punchline, null: false
      t.timestamps
    end

    create_table :episodes do |t|
      t.references :podcast, null: false, foreign_key: true
      t.string :guid, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.integer :file_size, null: false
      t.string :file_url, null: false
      t.datetime :published_at
      t.integer :duration
      t.boolean :explicit
      t.timestamps
    end
  end
end
