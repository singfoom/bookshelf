class LoginForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :password, :string

  validates :email, presence: { message: "can't be blank" }
  validates :password, presence: { message: "can't be blank" }, if: :email_present?
  validate :user_exists_and_password_valid

  def initialize(attributes = {})
    super
    self.email = email&.strip&.downcase
  end

  def authenticate
    return nil unless valid?
    user
  end

  def user
    @user ||= User.find_by(email: email) if email.present?
  end

  private

  def email_present?
    email.present?
  end

  def user_exists_and_password_valid
    return if password.blank? || email.blank?

    if user.nil?
      errors.add(:email, "not found")
    elsif !user.authenticate(password)
      errors.add(:password, "is incorrect")
    end
  end
end
