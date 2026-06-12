require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:kiryuanzu)
  end

  test "フィクスチャのユーザーは有効" do
    assert_predicate @user, :valid?
  end

  test "email は必須" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "email はメールアドレス形式のみ許可" do
    @user.email = "not-an-email"
    assert_not @user.valid?
  end

  test "email は大文字小文字を区別せず一意" do
    user = User.new(
      email: @user.email.upcase,
      name: "重複ユーザー",
      password: "password"
    )
    assert_not user.valid?
    assert user.errors[:email].present?
  end

  test "name は必須" do
    @user.name = nil
    assert_not @user.valid?
  end

  test "name は266文字以内" do
    @user.name = "あ" * 266
    assert_predicate @user, :valid?

    @user.name = "あ" * 267
    assert_not @user.valid?
  end

  test "password は6文字以上" do
    user = User.new(email: "new@example.com", name: "新規ユーザー", password: "12345")
    assert_not user.valid?

    user.password = "123456"
    assert_predicate user, :valid?
  end

  test "authenticate は正しいパスワードのみ成功する" do
    assert @user.authenticate("password")
    assert_not @user.authenticate("wrong-password")
  end
end
