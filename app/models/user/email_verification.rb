module User::EmailVerification
  extend ActiveSupport::Concern

  included do
    has_secure_password :email_verification_token, validations: false
    after_commit :initiate_email_verification, on: :create
  end

  class_methods do
    def find_by_email_verification_id(id)
      message_verifier.verified(
        CGI.unescape(id),
        purpose: :email_verification
      )&.symbolize_keys => {user_id:, email_verification_token:}
      User.find(user_id).authenticate_email_verification_token(email_verification_token)
    rescue ActiveRecord::RecordNotFound, NoMatchingPatternError
      nil
    end
  end

  def initiate_email_verification
    update(email_verification_token: self.class.generate_unique_secure_token)
    UserMailer.with(user: self).email_verification(CGI.escape(email_verification_id)).deliver_now
  end

  def complete_email_verification
    update(email_verification_token: nil)
  end

  def email_verified?
    email_verification_token_digest.blank?
  end

  private

  def email_verification_id
    message_verifier.generate({
      user_id: id,
      email_verification_token: email_verification_token
    }, purpose: :email_verification, expires_in: 2.hours)
  end
end
