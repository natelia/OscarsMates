class ApplicationMailer < ActionMailer::Base
  # SMTP_FROM is required in production (see compose.production.yml).
  default(from: -> { ENV.fetch('SMTP_FROM', 'from@example.com') })
  layout 'mailer'
end
