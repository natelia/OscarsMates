class OscarMailer < ApplicationMailer
  def nominations_reminder(user)
    @user = user
    mail(to: @user.email, subject: 'Oscar Nominations Reminder')
  end
end
