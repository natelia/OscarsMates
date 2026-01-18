require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:category) { create(:category) }
  let(:movie) { create(:movie) }
  let!(:nomination) { create(:nomination, movie: movie, category: category, year: 2025) }

  def sign_in(user)
    post create_session_path, params: { email: user.email, password: 'password' }
  end

  describe 'GET /users' do
    context 'when not logged in' do
      it 'redirects to signin' do
        get users_path

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when logged in' do
      before { sign_in(user) }

      it 'returns success' do
        get users_path

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'when not logged in' do
      it 'redirects to signin' do
        get user_path(other_user)

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when logged in' do
      before { sign_in(user) }

      it 'returns success' do
        get user_path(other_user)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(other_user.name)
      end
    end
  end

  describe 'POST /users' do
    let(:valid_params) do
      {
        user: {
          name: 'New User',
          email: 'newuser@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    it 'creates a new user' do
      expect do
        post users_path, params: valid_params
      end.to change(User, :count).by(1)
    end

    it 'logs in the new user' do
      post users_path, params: valid_params

      expect(session[:user_id]).to eq(User.last.id)
    end
  end
end
