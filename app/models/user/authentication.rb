module User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    attr_accessor :current_password
    validate :current_password_valid, on: :password_change
    validates :password, confirmation: true, length: {minimum: 8}, on: [:create, :password_change]
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
    password_digest_in_memory = password_digest
    self.password_digest = attribute_in_database(:password_digest)
    errors.add(:current_password, :incorrect_password) unless authenticate(current_password)
  ensure
    self.password_digest = password_digest_in_memory
  end
end
