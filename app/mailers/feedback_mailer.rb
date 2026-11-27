class FeedbackMailer < ApplicationMailer
  # FEEDBACK_EMAIL is required in production (see compose.production.yml).
  FALLBACK_RECIPIENT = 'feedback@example.com'.freeze

  def self.recipient
    ENV.fetch('FEEDBACK_EMAIL', FALLBACK_RECIPIENT)
  end

  def send_feedback(email:, message:, subject:, user_name: nil)
    @email = email
    @message = message
    @user_name = user_name

    mail(
      to: self.class.recipient,
      subject: "[OscarsMates] #{subject}",
      reply_to: email
    )
  end
end
