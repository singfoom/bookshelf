class SessionsController < ApplicationController
  before_action :require_guest, only: [ :new, :create ]

  def new
    @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new(email: params[:email], password: params[:password])

    if @login_form.authenticate
      log_in(@login_form.user)
      redirect_to root_path, notice: "Welcome back, #{@login_form.user.first_name}!"
    else
      # Email is already preserved in @login_form from params[:email]
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: "You have been logged out."
  end
end
