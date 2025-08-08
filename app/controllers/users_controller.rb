class UsersController < ApplicationController
  before_action :require_guest, only: [ :new, :create ]
  before_action :require_user, only: [ :show ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      redirect_to root_path, notice: "Welcome to Bookshelf, #{@user.first_name}!"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
