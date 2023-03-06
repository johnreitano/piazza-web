require "test_helper"

class User::EmailVerificationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @user = users(:jerry)
    ActionMailer::Base.deliveries.clear
  end

  test "verifying a user's email destroys sends verification email" do
    assert_nil @user.email_verification_token
    assert_nil @user.email_verification_token_digest
    @user.initiate_email_verification
    assert_emails 1
    assert_not_nil @user.email_verification_token
    assert_not_nil @user.email_verification_token_digest
  end

  test "can retrieve a user with a valid email verification id" do
    @user.initiate_email_verification
    email_verification_id = @user.send(:email_verification_id)
    user = User.find_by_email_verification_id(email_verification_id)
    assert_equal @user, user
  end

  test "retrieving a user with an invalid id returns nil" do
    assert_nil User.find_by_email_verification_id("invalid")
  end

  test "retrieving a user with an expired id returns nil" do
    @user.initiate_email_verification
    now = Time.zone.now
    email_verification_id = @user.send(:email_verification_id)
    travel_to now.advance(hours: 2, seconds: 0)
    assert_not_nil User.find_by_email_verification_id(email_verification_id)
    travel_to now.advance(hours: 2, seconds: 1)
    assert_nil User.find_by_email_verification_id(email_verification_id)
  end

  test "completing the email verification nillifies the email verification token" do
    @user.initiate_email_verification
    assert_not_nil @user.reload.email_verification_token_digest
    @user.complete_email_verification
    assert_nil @user.reload.email_verification_token_digest
  end
end
