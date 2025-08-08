require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      first_name: "John",
      last_name: "Doe",
      email: "newjohn@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first_name should be present" do
    @user.first_name = ""
    assert_not @user.valid?
  end

  test "last_name should be present" do
    @user.last_name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "NewJoHn@ExAmPlE.CoM"
    @user.email = mixed_case_email
    assert @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = ""
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "full_name should return first and last name" do
    assert_equal "John Doe", @user.full_name
  end

  test "full_name should handle whitespace properly" do
    @user.first_name = " John "
    @user.last_name = " Doe "
    @user.save
    assert_equal "John Doe", @user.full_name
  end
end
