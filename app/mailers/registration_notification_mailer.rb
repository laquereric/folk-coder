class RegistrationNotificationMailer < ApplicationMailer
  def new_signup(user)
    @user = user
    mail to: "activecodefirst@magenticmarket.ai", subject: "New FolkCoder Registration: #{user.name}"
  end
end
