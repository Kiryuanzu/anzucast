class EpisodesController < ApplicationController
  def index
    @episodes = Episode.order(published_at: :desc)
                       .page(params[:page])
                       .per(10)
  end

  def show
    @episode = Episode.find(params[:id])
  end
end
