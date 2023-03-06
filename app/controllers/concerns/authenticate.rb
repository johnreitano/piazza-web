module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :load_session_info
    before_action :require_login, unless: :logged_in?
    helper_method :logged_in?
  end

  class_methods do
    def skip_authentication(**options)
      skip_before_action :load_session_info, options
      skip_before_action :require_login, options
    end

    def allow_unauthenticated(**options)
      skip_before_action :require_login, options
    end
  end

  protected

  def logged_in?
    Current.user.present?
  end

  def log_in(app_session, remember_me)
    if remember_me
      cookies.encrypted.permanent[:app_session] = {value: app_session.to_h}
      session.delete :app_session
    else
      session[:app_session] = app_session.to_h
      cookies.delete :app_session
    end
  end

  def log_out
    Current.app_session&.destroy
  end

  private

  def require_login
    flash.now[:notice] = t("login_required")
    render "sessions/new", status: :unauthorized
  end

  def load_session_info
    Current.app_session = authenticate_using_cookie_or_rails_session
    Current.user = Current.app_session&.user
  end

  def authenticate_using_cookie_or_rails_session
    app_session = cookies.encrypted[:app_session] || session[:app_session]
    authenticate_using app_session&.with_indifferent_access
  end

  def authenticate_using(data)
    data => { user_id:, app_session:, token: }
    user = User.find(user_id)
    user.authenticate_app_session(app_session, token)
  rescue NoMatchingPatternError
    nil
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def get
  end
end
