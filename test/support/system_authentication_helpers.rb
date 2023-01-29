module SystemAuthenticationHelpers
  def log_in(user, password: "password", remember_me: false)
    visit login_path

    fill_in User.human_attribute_name(:email), with: user.email
    fill_in User.human_attribute_name(:password), with: password
    check User.human_attribute_name(:remember_me) if remember_me

    click_button I18n.t("sessions.new.submit")
    assert_current_path root_path
  end

  def log_out
    click_on "#current_user_name"
    click_on I18n.t("shared.navbar.logout")
  end
end
