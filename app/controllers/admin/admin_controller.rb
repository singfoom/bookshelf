class Admin::AdminController < ApplicationController
  layout "admin/application"
  
  before_action :require_user
  before_action :require_admin

  private

  def require_admin
    unless current_user&.admin?
      flash[:alert] = "Access denied. Admin privileges required."
      redirect_to root_path
    end
  end
end