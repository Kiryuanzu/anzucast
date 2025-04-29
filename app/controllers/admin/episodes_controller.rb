class Admin::EpisodesController < Admin::BaseController
  def index
    @episodes = Episode.order(published_at: :desc).all
    @episode = Episode.new
  end

  def create
    @episode = current_user.episodes.build(episode_params)

    if @episode.save
      redirect_to admin_episodes_path, notice: "エピソードを投稿しました"
    else
      @episodes = Episode.order(published_at: :desc)
      render :index, status: :bad_request
    end
  end

  private

  def episode_params
    params.require(:episode).permit(
      :title,
      :description,
      :summary,
      :published_at,
      :duration
    )
  end
end
