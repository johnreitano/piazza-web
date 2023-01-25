class UserTest < ActiveSupport::TestCase
  test "requires a name" do
    @user = User.new(name: "", email: "johndoe@example.com", password: "password", password_confirmation: "password")
    assert_not @user.valid?

    @user.name = "John"
    assert @user.valid?
  end

  test "requires a valid email" do
    @user = User.new(name: "John", email: "", password: "password", password_confirmation: "password")
    assert_not @user.valid?

    @user.email = "invalid"
    assert_not @user.valid?

    @user.email = "johndoe@example.com"
    assert @user.valid?
  end

  test "requires a unique email" do
    @existing_user = User.create(
      name: "John",
      email: "jd@example.com",
      password: "password",
      password_confirmation: "password"
    )
    assert @existing_user.persisted?

    @user = User.new(name: "Jon", email: "jd@example.com")
    assert_not @user.valid?
  end

  test "password length must be between 8 and ActiveModel's maximum" do
    @user = User.new(
      name: "Jane",
      email: "janedoe@example.com",
      password: "",
      password_confirmation: ""
    )
    assert_not @user.valid?

    @user.password = @user.password_confirmation = "password"
    assert @user.valid?

    max_length =
      ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = "a" * (max_length + 1)
    assert_not @user.valid?
  end
end
