class Episode::RssController < ApplicationController
    def index
      @episodes = Episode.order(published_at: :asc)

      respond_to do |format|
        format.rss { render layout: false }
      end
    end
end
