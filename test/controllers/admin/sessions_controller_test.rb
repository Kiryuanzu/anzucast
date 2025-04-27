require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_sessions_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_sessions_create_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_sessions_destroy_url
    assert_response :success
  end
end
