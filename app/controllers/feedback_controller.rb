class FeedbackController < ApplicationController
  before_action :check_rate_limit, only: %i[submit_bug submit_feature]

  def report_bug
    @feedback_type = 'Report a bug'
  end

  def request_feature
    @feedback_type = 'Request a feature'
  end

  def submit_bug
    send_feedback('Bug Report')
  end

  def submit_feature
    send_feedback('Feature Request')
  end

  private

  def send_feedback(subject_prefix)
    email = params[:email]
    message = params[:message]

    if message.length < 100
      flash[:alert] = 'Message must be at least 100 characters long.'
      redirect_back_or_to(root_path) and return
    end

    # Send email
    FeedbackMailer.send_feedback(
      email: email,
      message: message,
      subject: subject_prefix,
      user_name: current_user&.name
    ).deliver_later

    # Store timestamp in session
    session[:last_feedback_sent_at] = Time.current.to_i

    flash[:notice] = 'Thank you for your feedback! We\'ll review it shortly.'
    redirect_to root_path
  end

  def check_rate_limit
    last_sent_at = session[:last_feedback_sent_at]
    return unless last_sent_at && (Time.current.to_i - last_sent_at) < 300

    time_left = 300 - (Time.current.to_i - last_sent_at)
    flash[:alert] = "Please wait #{(time_left / 60.0).ceil} more minute(s) before sending another message."
    redirect_back_or_to(root_path) and return
  end
end
