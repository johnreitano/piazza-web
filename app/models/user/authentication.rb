module User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    attr_accessor :current_password
    validate :current_password_valid, on: :password_change
    validates :password, confirmation: true, length: {minimum: 8}, on: [:create, :password_change, :password_reset]
    has_many :app_sessions
  end

  class_methods do
    def create_app_session(email:, password:)
      user = User.find_by(email: email.downcase)
      user.app_sessions.create if user.present? && user.authenticate(password)
    end
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def current_password_valid
    errors.add(:current_password, :incorrect_password) unless matches_password_in_db?(current_password)
  end

  def matches_password_in_db?(current_password)
    digest = attribute_in_database(:password_digest)
    digest.present? && BCrypt::Password.new(digest).is_password?(current_password)
  end
end
