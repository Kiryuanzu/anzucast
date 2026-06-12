require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  setup do
    @original_domain = ENV["AWS_CLOUD_FRONT_DOMAIN"]
    ENV["AWS_CLOUD_FRONT_DOMAIN"] = "cdn.example.com"
    @episode = episodes(:latest)
  end

  teardown do
    ENV["AWS_CLOUD_FRONT_DOMAIN"] = @original_domain
  end

  test "cloudfront_audio_file_url は CloudFront ドメイン付きの URL を返す" do
    url = cloudfront_audio_file_url(@episode.audio_file)
    assert_equal "https://cdn.example.com/#{@episode.audio_file.blob.key}", url
  end

  test "cloudfront_audio_file_url は未添付なら nil を返す" do
    episode = Episode.new
    assert_nil cloudfront_audio_file_url(episode.audio_file)
  end

  test "cloudfront_cover_image_url は CloudFront ドメイン付きの URL を返す" do
    url = cloudfront_cover_image_url(@episode.cover_image)
    assert_equal "https://cdn.example.com/#{@episode.cover_image.blob.key}", url
  end

  # link_to で付与した target/rel は最後の sanitize で除去されるため、href とリンク文言のみ検証する
  test "description_included_url は URL をリンクに変換する" do
    html = description_included_url("詳細は https://example.com/notes をどうぞ。")

    assert_includes html, %(href="https://example.com/notes")
    assert_includes html, ">https://example.com/notes</a>"
    assert_includes html, "詳細は"
  end

  test "description_included_url は URL がなければそのまま返す" do
    assert_equal "ただのテキスト", description_included_url("ただのテキスト")
  end
end
