class FeedController < ApplicationController
  allow_unauthenticated
  skip_email_verification

  def show
  end
end
