class Users::EmailVerificationsController < ApplicationController
  skip_email_verification

  def new
    @invalid_link = !!params[:invalid_link]
  end

  def create
    Current.user.initiate_email_verification
    redirect_to new_users_email_verification_path, status: :see_other
  end

  def edit
    @user = User.find_by_email_verification_id(params[:id])
    unless @user.present?
      redirect_to new_users_email_verification_path(invalid_link: true), status: :see_other
      return
    end
    @user.complete_email_verification
    recede_or_redirect_to root_path, status: :see_other, flash: {success: t(".success", name: @user.name)}
  end
end
