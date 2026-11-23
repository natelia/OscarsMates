# Sends password reset emails to users.
class UserMailer < ApplicationMailer
  def password_reset(user, token)
    @user = user
    @token = token

    mail to: user.email, subject: 'Reset your OscarsMates password'
  end
end
