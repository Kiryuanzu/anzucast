require "test_helper"

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  test "一覧が表示される" do
    get root_url
    assert_response :success
    assert_includes response.body, episodes(:latest).title
    assert_includes response.body, episodes(:oldest).title
  end

  test "一覧は published_at の降順で表示される" do
    get episodes_url
    assert_response :success
    assert_operator response.body.index(episodes(:latest).title), :<, response.body.index(episodes(:oldest).title)
  end

  test "一覧に各エピソードの詳細ページへのリンクがある" do
    get episodes_url
    assert_select "a[href=?]", episode_path(episodes(:latest))
  end

  test "ページネーションのパラメータ付きでも表示できる" do
    get episodes_url(page: 2)
    assert_response :success
  end

  test "詳細が表示される" do
    episode = episodes(:latest)
    get episode_url(episode)

    assert_response :success
    assert_includes response.body, episode.title
    assert_select "audio source"
  end

  test "詳細の説明文に含まれる URL はリンクになる" do
    get episode_url(episodes(:latest))
    assert_select "a[href=?]", "https://example.com/notes"
  end

  test "存在しないエピソードは 404 を返す" do
    get episode_url(id: "no-such-id")
    assert_response :not_found
  end
end
