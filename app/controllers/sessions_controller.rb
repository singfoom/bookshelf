class SessionsController < ApplicationController
  before_action :require_guest, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    email = params[:email]&.downcase
    password = params[:password]
    @user = User.find_by(email: email)

    if @user && @user.authenticate(password)
      log_in(@user)
      redirect_to root_path, notice: "Welcome back, #{@user.first_name}!"
    else
      @user = User.new(email: params[:email])

      # Special case: any email entered with blank password - only show password error
      if email.present? && password.blank?
        @user.errors.add(:password, "can't be blank")
      else
        # Validate email independently
        if email.blank?
          @user.errors.add(:email, "can't be blank")
        elsif !User.exists?(email: email)
          @user.errors.add(:email, "not found")
        end

        # Validate password independently
        if password.blank?
          @user.errors.add(:password, "can't be blank")
        elsif email.present? && User.exists?(email: email)
          @user.errors.add(:password, "is incorrect")
        end
      end

      render :new, status: :unprocessable_content
    end
  end

  def destroy
    log_out
    redirect_to root_path, notice: "You have been logged out."
  end
end
