module VerifyEmail
  extend ActiveSupport::Concern

  included do
    before_action :require_email_verification, if: :logged_in_but_email_not_verified?
    helper_method :logged_in_but_email_not_verified?
  end

  class_methods do
    def skip_email_verification(**options)
      skip_before_action :require_email_verification, options
    end
  end

  protected

  def logged_in_but_email_not_verified?
    Current.user.present? && !Current.user.email_verified?
  end

  private

  def require_email_verification
    render new_users_email_verification_path, status: :unauthorized
  end
end
