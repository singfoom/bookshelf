class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include SessionsHelper

  private

  def require_user
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  def require_guest
    if logged_in?
      redirect_to root_path
    end
  end
end
