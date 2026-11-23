require 'rails_helper'

RSpec.describe 'Password resets', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user, email: 'reset@example.com', password: 'password123') }

  describe 'GET /password_reset/new' do
    it 'renders the request form' do
      get new_password_reset_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Reset Your Password')
    end
  end

  describe 'POST /password_reset' do
    context 'with a registered email' do
      it 'sends a reset email with a link' do
        expect do
          post password_reset_path, params: { email: user.email }
        end.to change { ActionMailer::Base.deliveries.size }.by(1)

        expect(response).to redirect_to(signin_path)
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to eq([user.email])
        expect(mail.body.encoded).to match(%r{/password_reset/edit\?token=[\w%-]{20,}})
      end
    end

    context 'with an unknown email' do
      it 'shows the same notice and sends nothing' do
        expect do
          post password_reset_path, params: { email: 'nobody@example.com' }
        end.not_to(change { ActionMailer::Base.deliveries.size })

        expect(response).to redirect_to(signin_path)
        expect(flash[:notice]).to eq('If that email is registered, a password reset link is on its way.')
      end
    end
  end

  describe 'GET /password_reset/edit' do
    it 'renders the form for a valid token' do
      token = user.generate_token_for(:password_reset)

      get edit_password_reset_path, params: { token: token }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Choose a New Password')
    end

    it 'redirects for a garbage token' do
      get edit_password_reset_path, params: { token: 'garbage' }

      expect(response).to redirect_to(new_password_reset_path)
      expect(flash[:alert]).to include('invalid or has expired')
    end

    it 'redirects when the token is missing' do
      get edit_password_reset_path

      expect(response).to redirect_to(new_password_reset_path)
    end

    it 'redirects for an expired token' do
      token = nil
      travel_to 31.minutes.ago do
        token = user.generate_token_for(:password_reset)
      end

      get edit_password_reset_path, params: { token: token }

      expect(response).to redirect_to(new_password_reset_path)
    end
  end

  describe 'PATCH /password_reset' do
    let(:token) { user.generate_token_for(:password_reset) }

    it 'changes the password and rotates the session token' do
      old_session_token = user.session_token

      patch password_reset_path, params: { token: token, password: 'newpassword123',
                                           password_confirmation: 'newpassword123' }

      expect(response).to redirect_to(signin_path)
      expect(user.reload.authenticate('newpassword123')).to be_truthy
      expect(user.authenticate('password123')).to be(false)
      expect(user.session_token).not_to eq(old_session_token)
    end

    it 'signs the user in with the new password afterwards' do
      patch password_reset_path, params: { token: token, password: 'newpassword123',
                                           password_confirmation: 'newpassword123' }

      post create_session_path, params: { email: user.email, password: 'newpassword123' }

      expect(session[:user_id]).to eq(user.id)
    end

    it 're-renders the form when passwords do not match' do
      patch password_reset_path, params: { token: token, password: 'newpassword123',
                                           password_confirmation: 'different' }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include('Choose a New Password')
      expect(user.reload.authenticate('password123')).to be_truthy
    end

    it 're-renders the form when the password is too short' do
      patch password_reset_path, params: { token: token, password: 'abc', password_confirmation: 'abc' }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'redirects for a garbage token' do
      patch password_reset_path, params: { token: 'garbage', password: 'newpassword123',
                                           password_confirmation: 'newpassword123' }

      expect(response).to redirect_to(new_password_reset_path)
      expect(user.reload.authenticate('password123')).to be_truthy
    end

    it 'rejects a token that was issued before another password change' do
      stale_token = user.generate_token_for(:password_reset)
      user.update(password: 'changedit123')

      patch password_reset_path, params: { token: stale_token, password: 'newpassword123',
                                           password_confirmation: 'newpassword123' }

      expect(response).to redirect_to(new_password_reset_path)
      expect(user.reload.authenticate('changedit123')).to be_truthy
    end
  end
end
