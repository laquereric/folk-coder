class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_path, alert: I18n.t("flash.rate_limited") }

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      RegistrationNotificationMailer.new_signup(@user).deliver_later
      start_new_session_for @user
      redirect_to root_path, notice: t("flash.welcome")
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @user.errors.add(:email_address, "is already taken")
    render :new, status: :unprocessable_entity
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation)
  end
end
