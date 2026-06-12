require "test_helper"

class Admin::EpisodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:kiryuanzu)
    @episode = episodes(:latest)
  end

  test "未ログインだと一覧はログインページへリダイレクトされる" do
    get admin_episodes_url
    assert_redirected_to admin_login_path
  end

  test "未ログインだと作成・編集・更新もログインページへリダイレクトされる" do
    post admin_episodes_url, params: { episode: { title: "test" } }
    assert_redirected_to admin_login_path

    get edit_admin_episode_url(@episode)
    assert_redirected_to admin_login_path

    patch admin_episode_url(@episode), params: { episode: { title: "test" } }
    assert_redirected_to admin_login_path
  end

  test "ログイン済みなら一覧が表示される" do
    log_in_as(@user)
    get admin_episodes_url

    assert_response :success
    assert_includes response.body, @episode.title
  end

  test "エピソードを作成できる" do
    log_in_as(@user)

    assert_difference("Episode.count", 1) do
      post admin_episodes_url, params: {
        episode: {
          title: "新しいエピソード",
          description: "新しい説明",
          published_at: Time.current,
          duration: "00:15:00",
          cover_image: fixture_file_upload("cover.png", "image/png"),
          audio_file: fixture_file_upload("audio.m4a", "audio/mp4")
        }
      }
    end

    assert_redirected_to admin_episodes_path

    episode = Episode.order(:created_at).last
    assert_equal "新しいエピソード", episode.title
    assert_equal @user, episode.user
    assert episode.guid.present?
    assert episode.cover_image.attached?
    assert episode.audio_file.attached?
    assert episode.audio_file.blob.key.end_with?(".m4a")
  end

  test "タイトルがないとエピソードを作成できない" do
    log_in_as(@user)

    assert_no_difference("Episode.count") do
      post admin_episodes_url, params: {
        episode: {
          title: "",
          description: "説明",
          published_at: Time.current,
          cover_image: fixture_file_upload("cover.png", "image/png"),
          audio_file: fixture_file_upload("audio.m4a", "audio/mp4")
        }
      }
    end

    assert_response :bad_request
  end

  test "編集ページが表示される" do
    log_in_as(@user)
    get edit_admin_episode_url(@episode)

    assert_response :success
    assert_includes response.body, @episode.title
  end

  test "エピソードを更新できる" do
    log_in_as(@user)
    patch admin_episode_url(@episode), params: { episode: { title: "更新後のタイトル" } }

    assert_redirected_to edit_admin_episode_path(@episode.id)
    assert_equal "更新後のタイトル", @episode.reload.title
  end

  test "音声ファイルを差し替えると古い blob が削除され新しいキーに .m4a が付く" do
    log_in_as(@user)
    old_blob_id = @episode.audio_file.blob.id

    patch admin_episode_url(@episode), params: {
      episode: { audio_file: fixture_file_upload("audio.m4a", "audio/mp4") }
    }

    assert_redirected_to edit_admin_episode_path(@episode.id)
    @episode.reload
    assert @episode.audio_file.attached?
    assert_not_equal old_blob_id, @episode.audio_file.blob.id
    assert @episode.audio_file.blob.key.end_with?(".m4a")
  end

  test "タイトルが不正だと更新できない" do
    log_in_as(@user)
    patch admin_episode_url(@episode), params: { episode: { title: "" } }

    assert_response :unprocessable_entity
    assert_not_equal "", @episode.reload.title
  end
end
