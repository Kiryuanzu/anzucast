require "test_helper"

class Episode::RssControllerTest < ActionDispatch::IntegrationTest
  test "RSS フィードが取得できる" do
    get episode_rss_url
    assert_response :success
    assert_equal "application/rss+xml", response.media_type
  end

  test "チャンネル情報が含まれる" do
    get episode_rss_url
    assert_includes response.body, "桐生あんず電波局"
    assert_includes response.body, %(xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd")
    assert_includes response.body, "<language>"
  end

  test "全エピソードが item として含まれる" do
    get episode_rss_url
    assert_equal Episode.count, response.body.scan("<item>").size
    assert_includes response.body, episodes(:latest).title
    assert_includes response.body, episodes(:oldest).title
  end

  test "エピソードは published_at の降順で並ぶ" do
    get episode_rss_url
    assert_operator response.body.index(episodes(:latest).title), :<, response.body.index(episodes(:oldest).title)
  end

  test "item に guid と pubDate と enclosure が含まれる" do
    get episode_rss_url
    episode = episodes(:latest)

    assert_includes response.body, %(<guid isPermaLink="false">#{episode.guid}</guid>)
    assert_includes response.body, episode.published_at.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    assert_includes response.body, %(type="audio/mp4")
    assert_includes response.body, episode.audio_file.blob.key
  end

  test "lastBuildDate は最新の更新日時になる" do
    get episode_rss_url
    expected = Episode.maximum(:updated_at).utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    assert_includes response.body, "<lastBuildDate>#{expected}</lastBuildDate>"
  end

  test "フィードの自己参照リンクが含まれる" do
    get episode_rss_url
    assert_includes response.body, %(href="http://www.example.com/episode/rss")
  end
end
