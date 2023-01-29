class Users::PasswordsController < ApplicationController
  def update
    @user = Current.user
    @user.current_password = params.dig(:user, :current_password)
    @user.password = params.dig(:user, :password)
    @user.password_confirmation = params.dig(:user, :password_confirmation)
    if @user.save(context: :password_change)
      flash[:success] = t(".success")
      redirect_to profile_path, status: :see_other
    else
      render "users/show", status: :unprocessable_entity
    end
  end
end
