require "application_system_test_case"

class Users::EmailVerificationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:jerry)
    ActionMailer::Base.deliveries.clear
  end

  test "can sign up and verify email" do
    visit sign_up_path
    fill_in "Name", with: "foo"
    fill_in "Email", with: "foo@example.com"
    fill_in "Password", with: "123123123"
    fill_in "Password confirmation", with: "123123123"
    click_on I18n.t("users.new.sign_up")
    assert_current_path new_users_email_verification_path
    visit extract_primary_link_from_last_mail
    assert_current_path root_path
  end
end
