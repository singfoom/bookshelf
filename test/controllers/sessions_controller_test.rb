require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
  end

  test "should get new" do
    get login_path
    assert_response :success
    assert_select "h1", "Welcome Back"
  end

  test "should redirect new when logged in" do
    log_in_as(@user)
    get login_path
    assert_redirected_to root_path
  end

  test "should login with valid information" do
    post login_path, params: {
      email: @user.email,
      password: "password123"
    }
    assert_redirected_to root_path
    assert flash[:notice]
    assert is_logged_in?
  end

  test "should not login with invalid email" do
    post login_path, params: {
      email: "nonexistent@example.com",
      password: "password123"
    }
    assert_response :unprocessable_content
    assert flash[:alert]
    assert_not is_logged_in?
  end

  test "should not login with invalid password" do
    post login_path, params: {
      email: @user.email,
      password: "wrongpassword"
    }
    assert_response :unprocessable_content
    assert flash[:alert]
    assert_not is_logged_in?
  end

  test "should logout" do
    log_in_as(@user)
    assert is_logged_in?
    delete logout_path
    assert_redirected_to root_path
    assert flash[:notice]
    assert_not is_logged_in?
  end
end
