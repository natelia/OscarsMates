class FeedbackMailer < ApplicationMailer
  default from: 'noreply@oscarsmates.com'

  def send_feedback(email:, message:, subject:, user_name: nil)
    @email = email
    @message = message
    @user_name = user_name

    mail(
      to: 'lunaenumen@gmail.com',
      subject: "[OscarsMates] #{subject}",
      reply_to: email
    )
  end
end
