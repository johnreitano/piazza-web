# manages authenticated user
class UsersController < ApplicationController
  skip_authentication only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    unless @user.save
      render :new, status: :unprocessable_entity
      return
    end

    @organization = Organization.create(members: [@user])
    @app_session = @user.app_sessions.create
    log_in(@app_session, false)
    redirect_to new_users_email_verification_path, status: :see_other
  end

  def show
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update(update_params)
      flash[:success] = t(".success")
      redirect_to profile_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
