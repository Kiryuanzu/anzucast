require "test_helper"

class Episode::RssControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get episode_rss_index_url
    assert_response :success
  end
end
