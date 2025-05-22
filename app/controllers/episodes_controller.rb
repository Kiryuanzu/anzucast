class EpisodesController < ApplicationController
  def index
    @episodes = Episode.where("published_at <= ?", Time.current)
                       .order(published_at: :desc)
                       .page(params[:page])
                       .per(10)
  end

  def show
    @episode = Episode.find(params[:id])
  end
end
