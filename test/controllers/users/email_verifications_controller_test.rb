require "test_helper"

class Users::EmailVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jerry)
    log_in(@user)
    ActionMailer::Base.deliveries.clear
  end

  test "requesting an email verification sends an email and shows instructions" do
    post users_email_verifications_path
    assert_response :see_other
    follow_redirect!
    assert_select "p", text: I18n.t("users.email_verifications.new.link_sent")
    assert_emails 1
  end

  test "following an invalid email verification link redirects" do
    @user.initiate_email_verification
    get edit_users_email_verification_path("invalid_id")
    assert_redirected_to new_users_email_verification_path(invalid_link: true)
  end

  test "following a valid email verification link redirects the user to the root" do
    @user.initiate_email_verification
    id = CGI.escape(@user.send(:email_verification_id))
    get edit_users_email_verification_path(id)
    assert_redirected_to root_path
  end
end
