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

      it 'sets an httponly remember-me cookie when Remember me is checked' do
        post create_session_path, params: { email: user.email, password: 'password123', remember_me: '1' }

        set_cookie = Array(response.headers['Set-Cookie']).join("\n").downcase
        expect(set_cookie).to include('remember_me=')
        expect(set_cookie).to include('httponly')
        expect(set_cookie).to include('samesite=lax')
      end
    end

    context 'with invalid credentials' do
      it 'renders the login form with error' do
        post create_session_path, params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('Invalid email/password combination!')
      end
    end

    context 'with non-existent email' do
      it 'renders the login form with error' do
        post create_session_path, params: { email: 'nonexistent@example.com', password: 'password' }

        expect(response).to have_http_status(:unprocessable_content)
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

    it 'deletes the remember-me cookie' do
      delete destroy_session_path

      expect(response.cookies['remember_me']).to be_nil
    end
  end

  describe 'remember-me cookie' do
    def sign_in_with_remember
      post create_session_path, params: { email: user.email, password: 'password123', remember_me: '1' }
    end

    it 'is not set when Remember me is unchecked' do
      post create_session_path, params: { email: user.email, password: 'password123' }

      expect(cookies[:remember_me]).to be_nil
    end

    it 'authenticates from the cookie when the session is empty' do
      sign_in_with_remember
      remember_cookie = cookies[:remember_me]
      reset! # clears session and cookies, then restore only the remember cookie
      cookies[:remember_me] = remember_cookie

      get edit_user_path(user)

      expect(response).to have_http_status(:ok)
    end

    it 'no longer authenticates after the password changes' do
      old_token = user.session_token
      sign_in_with_remember
      remember_cookie = cookies[:remember_me]
      reset!
      cookies[:remember_me] = remember_cookie

      patch user_path(user), params: { user: { password: 'newpassword123', password_confirmation: 'newpassword123' } }
      get edit_user_path(user)

      expect(response).to redirect_to(new_session_url)
      expect(user.reload.session_token).not_to eq(old_token)
    end

    it 'rejects a corrupt or tampered cookie' do
      cookies[:remember_me] = 'garbage'

      get edit_user_path(user)

      expect(response).to redirect_to(new_session_url)
    end
  end
end
