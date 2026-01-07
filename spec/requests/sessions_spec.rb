require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe 'GET /signin' do
    it 'renders the login form' do
      get signin_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /session' do
    context 'with valid credentials' do
      it 'logs in the user and sets session' do
        post create_session_path, params: { email: user.email, password: 'password123' }

        expect(response).to have_http_status(:redirect)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      it 'renders the login form with error' do
        post create_session_path, params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Invalid email/password combination!')
      end
    end

    context 'with non-existent email' do
      it 'renders the login form with error' do
        post create_session_path, params: { email: 'nonexistent@example.com', password: 'password' }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /session' do
    before do
      post create_session_path, params: { email: user.email, password: 'password123' }
    end

    it 'logs out the user and clears session' do
      delete destroy_session_path

      expect(response).to have_http_status(:redirect)
      expect(session[:user_id]).to be_nil
    end
  end
end
