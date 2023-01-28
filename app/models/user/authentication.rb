module User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    validates :password,
      presence: true,
      confirmation: true,
      length: {minimum: 8}
    validates :password_confirmation, presence: true
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
end
