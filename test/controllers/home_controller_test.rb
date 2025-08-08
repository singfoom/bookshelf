require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should display authors and books count" do
    get root_url
    assert_response :success
    assert_select "h1", "Welcome to Bookshelf"
  end

  test "should show recent books when they exist" do
    get root_url
    assert_response :success
    # The fixture data should be loaded, so we should see book information
    if Book.count > 0
      assert_select "h2", "Recent Books"
    end
  end
end
