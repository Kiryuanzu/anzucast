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
      @episodes = Episode.order(published_at: :desc).page(params[:page]).per(10)
      render :index, status: :bad_request
    end
  end

  def edit
    @episode = Episode.find(params[:id])
  end

  def update
    @episode = Episode.find(params[:id])

    if @episode.update(episode_edit_params)
      redirect_to edit_admin_episode_path(@episode.id), notice: "エピソードを更新しました"
    else
      render :edit, status: :unprocessable_entity
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

  def episode_edit_params
    params.require(:episode).permit(
      :title,
      :description,
      :published_at,
      :duration,
      :guid
    )
  end
end
