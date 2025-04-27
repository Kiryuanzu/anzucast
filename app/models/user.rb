class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 1, maximum: 266 }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
