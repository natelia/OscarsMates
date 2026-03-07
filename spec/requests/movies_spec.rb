require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:category) { create(:category) }
  let(:movie) { create(:movie) }
  let!(:nomination) { create(:nomination, movie: movie, category: category, year: 2025) }

  def sign_in(user)
    post create_session_path, params: { email: user.email, password: 'password' }
  end

  describe 'GET /:year/movies' do
    it 'returns success when year is specified' do
      get '/2025/movies'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(movie.title)
    end

    context 'when user is logged in' do
      before { sign_in(user) }

      it 'shows movies list' do
        get '/2025/movies'

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /:year/movies/:id' do
    it 'returns success' do
      get "/2025/movies/#{movie.slug}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(movie.title)
    end

    it 'uses back_to param for the details back button' do
      get "/2025/movies/#{movie.slug}", params: { back_to: '/2025/timeline' }, headers: {
        'HTTP_REFERER' => "http://www.example.com/2025/movies/#{movie.slug}/edit"
      }

      expect(response.body).to include('href="/2025/timeline"')
    end

    it 'ignores transient referer pages for the details back button' do
      get "/2025/movies/#{movie.slug}", headers: {
        'HTTP_REFERER' => "http://www.example.com/2025/movies/#{movie.slug}/edit"
      }

      expect(response.body).to include("href=\"#{movies_path(year: 2025)}\"")
    end
  end

  describe 'GET /:year/movies/new' do
    context 'when not logged in' do
      it 'redirects to signin' do
        get '/2025/movies/new'

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when logged in as non-admin' do
      before { sign_in(user) }

      it 'redirects with unauthorized message' do
        get '/2025/movies/new'

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in as admin' do
      before { sign_in(admin) }

      it 'returns success' do
        get '/2025/movies/new'

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /:year/movies' do
    let(:valid_params) do
      {
        movie: {
          title: 'New Movie',
          english_title: 'New Movie EN',
          where_to_watch: 'Cinema',
          runtime: 120,
          rating: 8,
          url: 'http://example.com',
          picture_url: 'http://example.com/pic.jpg'
        }
      }
    end

    context 'when logged in as admin' do
      before { sign_in(admin) }

      it 'creates a new movie' do
        expect do
          post '/2025/movies', params: valid_params
        end.to change(Movie, :count).by(1)
      end

      it 'redirects to the new movie' do
        post '/2025/movies', params: valid_params

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'PATCH /:year/movies/:id' do
    before { sign_in(admin) }

    it 'redirects back to movie details with preserved back_to context' do
      patch "/2025/movies/#{movie.slug}", params: {
        movie: { runtime: movie.runtime + 1 },
        back_to: '/2025/timeline'
      }

      expect(response).to redirect_to(movie_path(movie, year: 2025, back_to: '/2025/timeline'))
    end

    it 'ignores unsafe back_to values' do
      patch "/2025/movies/#{movie.slug}", params: {
        movie: { runtime: movie.runtime + 1 },
        back_to: '//evil.example'
      }

      expect(response).to redirect_to(movie_path(movie, year: 2025))
    end
  end
end
