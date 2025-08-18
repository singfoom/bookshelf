require "test_helper"

class LoginFormTest < ActiveSupport::TestCase
  def setup
    @user = users(:john)
  end

  test "should authenticate with valid email and password" do
    login_form = LoginForm.new(email: @user.email, password: "password123")
    authenticated_user = login_form.authenticate

    assert_equal @user, authenticated_user
  end

  test "should not authenticate with invalid email" do
    login_form = LoginForm.new(email: "nonexistent@example.com", password: "password123")
    authenticated_user = login_form.authenticate

    assert_nil authenticated_user
    assert_equal [ "not found" ], login_form.errors[:email]
  end

  test "should not authenticate with invalid password" do
    login_form = LoginForm.new(email: @user.email, password: "wrongpassword")
    authenticated_user = login_form.authenticate

    assert_nil authenticated_user
    assert_equal [ "is incorrect" ], login_form.errors[:password]
  end

  test "should not authenticate with blank email" do
    login_form = LoginForm.new(email: "", password: "password123")
    authenticated_user = login_form.authenticate

    assert_nil authenticated_user
    assert_equal [ "can't be blank" ], login_form.errors[:email]
  end

  test "should not authenticate with blank password" do
    login_form = LoginForm.new(email: @user.email, password: "")
    authenticated_user = login_form.authenticate

    assert_nil authenticated_user
    assert_equal [ "can't be blank" ], login_form.errors[:password]
  end

  test "should not authenticate with both blank" do
    login_form = LoginForm.new(email: "", password: "")
    authenticated_user = login_form.authenticate

    assert_nil authenticated_user
    assert_equal [ "can't be blank" ], login_form.errors[:email]
    assert_empty login_form.errors[:password]  # Password not validated when email is blank
  end

  test "should downcase email on initialization" do
    login_form = LoginForm.new(email: "USER@EXAMPLE.COM", password: "password123")

    assert_equal "user@example.com", login_form.email
  end

  test "should handle nil email gracefully" do
    login_form = LoginForm.new(email: nil, password: "password123")

    assert_nil login_form.email
  end

  test "should provide access to user object" do
    login_form = LoginForm.new(email: @user.email, password: "password123")

    assert_equal @user, login_form.user
  end

  test "should return nil for user when email is invalid" do
    login_form = LoginForm.new(email: "nonexistent@example.com", password: "password123")

    assert_nil login_form.user
  end

  test "should handle case insensitive email for authentication" do
    login_form = LoginForm.new(email: @user.email.upcase, password: "password123")
    authenticated_user = login_form.authenticate

    assert_equal @user, authenticated_user
  end

  test "should validate presence of email" do
    login_form = LoginForm.new(email: "", password: "password123")

    assert_not login_form.valid?
    assert_equal [ "can't be blank" ], login_form.errors[:email]
  end

  test "should validate presence of password when email is present" do
    login_form = LoginForm.new(email: @user.email, password: "")

    assert_not login_form.valid?
    assert_equal [ "can't be blank" ], login_form.errors[:password]
    assert_empty login_form.errors[:email]
  end

  test "should not validate password when email is blank" do
    login_form = LoginForm.new(email: "", password: "")

    assert_not login_form.valid?
    assert_equal [ "can't be blank" ], login_form.errors[:email]
    assert_empty login_form.errors[:password]  # Password not validated when email is blank
  end

  test "should validate user exists and password is correct" do
    login_form = LoginForm.new(email: @user.email, password: "password123")

    assert login_form.valid?
    assert login_form.errors.empty?
  end

  test "should be invalid when user does not exist" do
    login_form = LoginForm.new(email: "nonexistent@example.com", password: "password123")

    assert_not login_form.valid?
    assert_equal [ "not found" ], login_form.errors[:email]
  end

  test "should be invalid when password is incorrect" do
    login_form = LoginForm.new(email: @user.email, password: "wrongpassword")

    assert_not login_form.valid?
    assert_equal [ "is incorrect" ], login_form.errors[:password]
  end
end
