class Admin::EpisodesController < Admin::BaseController
  def index
    @episodes = Episode.order(published_at: :desc).page(params[:page]).per(10)
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
      :published_at,
      :duration,
      :cover_image,
      :audio_file
    )
  end
end
