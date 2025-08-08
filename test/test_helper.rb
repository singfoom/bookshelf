ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  # Log in as a particular user
  def log_in_as(user, password: "password123")
    post login_path, params: { email: user.email, password: password }
  end

  # Returns true if a test user is logged in
  def is_logged_in?
    !session[:user_id].nil?
  end
end
