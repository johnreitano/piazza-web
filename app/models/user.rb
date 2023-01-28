class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_secure_password
  has_many :app_sessions

  validates :password,
    presence: true,
    confirmation: true,
    length: {minimum: 8}
  validates :password_confirmation, presence: true

  validates :name, presence: true
  validates :email,
    format: {with: URI::MailTo::EMAIL_REGEXP},
    uniqueness: {case_sensitive: false}

  before_validation :strip_extraneous_spaces

  def self.create_app_session(email:, password:)
    user = User.find_by(email: email.downcase)
    user.app_sessions.create if user.present? && user.authenticate(password)
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

  def strip_extraneous_spaces
    self.name = name&.strip
    self.email = email&.strip
  end
end
