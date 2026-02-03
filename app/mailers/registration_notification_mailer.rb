class RegistrationNotificationMailer < ApplicationMailer
  def new_signup(user)
    @user = user
    mail to: "activecodefirst@magenticmarket.ai", subject: t("mailers.registration_notification.subject", name: user.name)
  end
end
