require "test_helper"

class Admin::AdminControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:john)
  end

  test "should require login to access admin" do
    get admin_root_path
    assert_redirected_to login_path
    assert_equal "You must be logged in to access this page.", flash[:alert]
  end

  test "should require admin privileges" do
    log_in_as(@user)
    get admin_root_path
    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "should allow admin access" do
    log_in_as(@admin)
    get admin_root_path
    assert_response :success
  end

  private

  def log_in_as(user)
    post login_path, params: { email: user.email, password: user.admin? ? 'admin123' : 'password123' }
  end
end