require "test_helper"

class EpisodeTest < ActiveSupport::TestCase
  setup do
    @episode = episodes(:latest)
  end

  test "フィクスチャのエピソードは有効" do
    assert_predicate @episode, :valid?
  end

  test "title は必須" do
    @episode.title = nil
    assert_not @episode.valid?
  end

  test "title は200文字以内" do
    @episode.title = "あ" * 200
    assert_predicate @episode, :valid?

    @episode.title = "あ" * 201
    assert_not @episode.valid?
  end

  test "description は必須" do
    @episode.description = nil
    assert_not @episode.valid?
  end

  test "published_at は必須" do
    @episode.published_at = nil
    assert_not @episode.valid?
  end

  test "cover_image は必須" do
    @episode.cover_image.detach
    assert_not @episode.valid?
  end

  test "audio_file は必須" do
    @episode.audio_file.detach
    assert_not @episode.valid?
  end

  test "guid は作成時に自動採番される" do
    episode = build_episode(title: "新しいエピソード")

    assert episode.save
    assert_match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/, episode.guid)
  end

  test "guid は一意" do
    episode = build_episode(title: "重複GUID", guid: episodes(:oldest).guid)

    assert_not episode.valid?
    assert episode.errors[:guid].present?
  end

  test "cover_image は PNG/JPEG 以外を拒否する" do
    episode = build_episode(cover_content_type: "image/gif")
    assert_not episode.valid?
    assert_includes episode.errors[:cover_image], "は PNG, JPEG形式のみ対応しています"
  end

  test "audio_file は MP3/M4A 以外を拒否する" do
    episode = build_episode(audio_content_type: "audio/wav")
    assert_not episode.valid?
    assert_includes episode.errors[:audio_file], "は MP3, M4A形式のみ対応しています"
  end

  test "attachable_storage_path は .m4a 拡張子付きのキーを返す" do
    path = @episode.attachable_storage_path
    assert path.end_with?(".m4a")
    assert_operator path.length, :>, ".m4a".length
  end

  test "audio_file_attach で添付すると blob のキーに .m4a 拡張子が付く" do
    upload = Rack::Test::UploadedFile.new(file_fixture("audio.m4a"), "audio/mp4")
    @episode.audio_file_attach(upload)

    assert @episode.audio_file.attached?
    assert @episode.audio_file.blob.key.end_with?(".m4a")
    assert_equal "audio/mp4", @episode.audio_file.content_type
  end

  private

  def build_episode(cover_content_type: "image/png", audio_content_type: "audio/mp4", **attributes)
    episode = users(:kiryuanzu).episodes.build(
      { title: "テストエピソード", description: "説明", published_at: Time.current }.merge(attributes)
    )
    # ファイル内容からの content_type 自動判別を止め、引数で渡した content_type のまま検証できるようにする
    episode.cover_image.attach(io: file_fixture("cover.png").open, filename: "cover.png", content_type: cover_content_type, identify: false)
    episode.audio_file.attach(io: file_fixture("audio.m4a").open, filename: "audio.m4a", content_type: audio_content_type, identify: false)
    episode
  end
end
