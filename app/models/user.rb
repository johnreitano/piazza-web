class User < ApplicationRecord
  include EmailVerification
  include PasswordReset
  include Authentication

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  before_validation :strip_extraneous_spaces

  validates :name, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, uniqueness: {case_sensitive: false}

  private

  def strip_extraneous_spaces
    self.name = name&.strip
    self.email = email&.strip
  end
end
