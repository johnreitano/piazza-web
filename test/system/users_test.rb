require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "new user can sign up" do
    visit root_path

    click_on I18n.t("shared.navbar.sign_up")

    fill_in User.human_attribute_name(:name), with: "Newman"
    fill_in User.human_attribute_name(:email), with: "newman@example.com"
    fill_in "user_password", with: "short"
    fill_in "user_password_confirmation", with: "short"

    click_on I18n.t("users.new.sign_up")
    assert_selector "p.is-danger", text: I18n.t("activerecord.errors.models.user.attributes.password.too_short")

    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_on I18n.t("users.new.sign_up")

    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("users.create.welcome", name: "Newman")
    assert_selector ".navbar-dropdown", visible: false
  end

  test "existing user can login" do
    visit root_path

    click_link I18n.t("shared.navbar.login")

    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in "user_password", with: "wrong"

    click_button I18n.t("sessions.new.submit")

    assert_selector ".notification.is-danger", text: I18n.t("sessions.create.incorrect_details")

    fill_in User.human_attribute_name(:email), with: "jerry@example.com"
    fill_in "user_password", with: "password"
    click_button I18n.t("sessions.new.submit")

    assert_current_path root_path
    assert_selector ".notification", text: I18n.t("sessions.create.success")
    assert_selector ".navbar-dropdown", visible: false
  end

  test "can update name" do
    log_in(users(:jerry))

    visit profile_path

    fill_in User.human_attribute_name(:name), with: "Jerry Seinfeld"
    click_button I18n.t("users.show.save_profile")

    assert_selector "form .notification", text: I18n.t("users.update.success")
    assert_selector "#current_user_name", text: "Jerry Seinfeld"
  end

  test "can change password" do
    log_in(users(:jerry))

    visit profile_path

    fill_in "user_current_password", with: "password"
    fill_in "user_password", with: "password2"
    fill_in "user_password_confirmation", with: "password2"
    click_button I18n.t("users.show.change_password_button")
    assert_selector "form .notification", text: I18n.t("users.password_change.success")

    fill_in "user_current_password", with: "password2"
    fill_in "user_password", with: "password3"
    fill_in "user_password_confirmation", with: "password3"
    click_button I18n.t("users.show.change_password_button")
    assert_selector "form .notification", text: I18n.t("users.password_change.success")
  end

  test "can log out on desktop" do
    log_in(users(:jerry))
    assert_current_path root_path
  end
end
