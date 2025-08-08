class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_save { self.email = email.downcase }
  before_save :normalize_names

  def full_name
    "#{first_name.to_s.strip} #{last_name.to_s.strip}".strip
  end

  private

  def normalize_names
    self.first_name = first_name.strip if first_name
    self.last_name = last_name.strip if last_name
  end
end
