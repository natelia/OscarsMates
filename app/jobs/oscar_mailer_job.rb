class OscarMailerJob < ApplicationJob
  queue_as :default

  def perform(user)
    OscarMailer.nominations_reminder(user).deliver_later
  end
end
