require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:kiryuanzu)
  end

  test "ログインフォームが表示される" do
    get admin_login_url
    assert_response :success
  end

  test "正しい認証情報でログインできる" do
    post admin_login_url, params: { email: @user.email, password: "password" }

    assert_redirected_to admin_episodes_path
    follow_redirect!
    assert_response :success
  end

  test "パスワードが間違っているとログインできない" do
    post admin_login_url, params: { email: @user.email, password: "wrong-password" }

    assert_response :unprocessable_entity
    assert_includes response.body, "パスワードが違っています"
  end

  test "存在しないメールアドレスではログインできない" do
    post admin_login_url, params: { email: "nobody@example.com", password: "password" }

    assert_response :unprocessable_entity
  end

  test "ログアウトすると管理画面にアクセスできなくなる" do
    log_in_as(@user)
    delete admin_logout_url
    assert_redirected_to admin_login_path

    get admin_episodes_url
    assert_redirected_to admin_login_path
  end
end
