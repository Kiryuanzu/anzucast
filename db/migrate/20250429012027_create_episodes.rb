class CreateEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_table :episodes do |t|
      t.string :title
      t.text :description
      t.text :summary
      t.datetime :published_at
      t.string :duration
      t.string :guid
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
