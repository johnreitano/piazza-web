class FeedController < ApplicationController
  skip_authentication only: [:show]
  def show
  end
end
