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
    assert_select ".error-message", "Email not found"
    assert_not is_logged_in?
  end

  test "should not login with invalid password" do
    post login_path, params: {
      email: @user.email,
      password: "wrongpassword"
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Password is incorrect"
    assert_select ".error-message", { count: 1 }, "Should only show password error, not email error"
    assert_not is_logged_in?
  end

  test "should not login with nil email" do
    post login_path, params: {
      email: nil,
      password: "password123"
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Email can't be blank"
    assert_not is_logged_in?
  end

  test "should not login with empty email" do
    post login_path, params: {
      email: "",
      password: "password123"
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Email can't be blank"
    assert_not is_logged_in?
  end

  test "should not login with blank password" do
    post login_path, params: {
      email: @user.email,
      password: ""
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Password can't be blank"
    assert_select ".error-message", { count: 1 }, "Should only show password error for valid email + blank password"
    assert_not is_logged_in?
  end

  test "should not login with nil password" do
    post login_path, params: {
      email: @user.email,
      password: nil
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Password can't be blank"
    assert_select ".error-message", { count: 1 }, "Should only show password error for valid email + nil password"
    assert_not is_logged_in?
  end

  test "should not login with both email and password blank" do
    post login_path, params: {
      email: "",
      password: ""
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Email can't be blank"
    assert_select ".error-message", { count: 1 }, "Should only show email error when both are blank"
    assert_not is_logged_in?
  end

  test "should not login with both email and password nil" do
    post login_path, params: {
      email: nil,
      password: nil
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Email can't be blank"
    assert_select ".error-message", { count: 1 }, "Should only show email error when both are nil"
    assert_not is_logged_in?
  end

  test "should not login with invalid email and blank password - only show password error" do
    post login_path, params: {
      email: "nonexistent@example.com",
      password: ""
    }
    assert_response :unprocessable_content
    assert_select ".error-message", "Password can't be blank"
    assert_select ".error-message", { count: 1 }, "Should only show password error when any email is entered with blank password"
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
