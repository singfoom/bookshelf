class SessionsController < ApplicationController
  before_action :require_guest, only: [ :new, :create ]

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to root_path, notice: "Welcome back, #{user.first_name}!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: "You have been logged out."
  end
end
