require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "h1", "Join Bookshelf"
  end

  test "should redirect new when logged in" do
    log_in_as(@user)
    get signup_path
    assert_redirected_to root_path
  end

  test "should create user with valid information" do
    assert_difference "User.count", 1 do
      post signup_path, params: { user: {
        first_name: "Test",
        last_name: "User",
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      } }
    end
    assert_redirected_to root_path
    assert flash[:notice]
    assert is_logged_in?
  end

  test "should not create user with invalid information" do
    assert_no_difference "User.count" do
      post signup_path, params: { user: {
        first_name: "",
        last_name: "",
        email: "invalid",
        password: "123",
        password_confirmation: "456"
      } }
    end
    assert_response :unprocessable_content
    assert_select "div.error-messages"
  end

  test "should show user profile when logged in" do
    log_in_as(@user)
    get user_path(@user)
    assert_response :success
    assert_select "h2.profile-name", @user.full_name
  end

  test "should redirect to login when accessing profile while logged out" do
    get user_path(@user)
    assert_redirected_to login_path
    assert flash[:alert]
  end
end
