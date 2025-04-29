class CreateEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_table :episodes do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :summary
      t.datetime :published_at, null: false
      t.string :duration
      t.string :guid, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :episodes, :guid, unique: true
  end
end
