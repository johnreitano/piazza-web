class ApplicationController < ActionController::Base
  include Authenticate
  include VerifyEmail

  helper_method :turbo_frame_request?
  helper_method :turbo_native_app?
end
