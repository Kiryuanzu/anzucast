class Episode::RssController < ApplicationController
    def index
      @last_build_date = Episode.maximum(:updated_at)&.utc&.strftime("%a, %d %b %Y %H:%M:%S GMT")
      @episodes = Episode.order(published_at: :desc)

      respond_to do |format|
        format.rss { render layout: false }
      end
    end
end
