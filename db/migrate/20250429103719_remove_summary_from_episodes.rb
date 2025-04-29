class RemoveSummaryFromEpisodes < ActiveRecord::Migration[8.0]
  def change
    remove_column :episodes, :summary, :string
  end
end
