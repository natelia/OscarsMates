require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
  end

  describe 'GET #report_bug' do
    it 'returns a successful response' do
      get :report_bug

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #request_feature' do
    it 'returns a successful response' do
      get :request_feature

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #submit_bug' do
    it 'rejects messages shorter than 100 characters' do
      post :submit_bug, params: { email: 'test@example.com', message: 'short' }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Message must be at least 100 characters long.')
      expect(enqueued_jobs).to be_empty
    end

    it 'enqueues feedback email and stores rate limit timestamp' do
      message = 'a' * 100

      expect do
        post :submit_bug, params: { email: 'test@example.com', message: message }
      end.to have_enqueued_mail(FeedbackMailer, :send_feedback).with(
        email: 'test@example.com',
        message: message,
        subject: 'Bug Report',
        user_name: nil
      )

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Thank you for your feedback! We'll review it shortly.")
      expect(session[:last_feedback_sent_at]).to be_present
    end

    it 'rate limits repeated submissions' do
      session[:last_feedback_sent_at] = Time.current.to_i - 60
      request.env['HTTP_REFERER'] = '/report-bug'

      post :submit_bug, params: { email: 'test@example.com', message: 'a' * 100 }

      expect(response).to redirect_to('/report-bug')
      expect(flash[:alert]).to match(/Please wait/)
      expect(enqueued_jobs).to be_empty
    end
  end
end
