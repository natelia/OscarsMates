require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:movie) { create(:movie) }
  let!(:nomination) { create(:nomination, movie: movie, category: category, year: 2025) }

  def sign_in(user)
    post create_session_path, params: { email: user.email, password: 'password' }
  end

  describe 'POST /:year/movies/:movie_id/reviews' do
    let(:valid_params) do
      {
        review: {
          stars: 8,
          watched_on: Time.current
        }
      }
    end

    context 'when not logged in' do
      it 'redirects to signin' do
        post "/2025/movies/#{movie.slug}/reviews", params: valid_params

        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'when logged in' do
      before { sign_in(user) }

      it 'creates a new review' do
        expect do
          post "/2025/movies/#{movie.slug}/reviews", params: valid_params
        end.to change(Review, :count).by(1)
      end

      it 'redirects to the movie' do
        post "/2025/movies/#{movie.slug}/reviews", params: valid_params

        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to return_to when provided' do
        post "/2025/movies/#{movie.slug}/reviews", params: valid_params.merge(return_to: '/2025/timeline')

        expect(response).to redirect_to('/2025/timeline')
      end

      it 'ignores unsafe return_to values' do
        post "/2025/movies/#{movie.slug}/reviews", params: valid_params.merge(return_to: '//evil.example')

        expect(response).to redirect_to(movies_path(year: 2025))
      end
    end
  end

  describe 'DELETE /:year/movies/:movie_id/reviews/:id' do
    let!(:review) { create(:review, user: user, movie: movie) }

    context 'when logged in as review owner' do
      before { sign_in(user) }

      it 'deletes the review' do
        expect do
          delete "/2025/movies/#{movie.slug}/reviews/#{review.id}"
        end.to change(Review, :count).by(-1)
      end
    end
  end

  describe 'PATCH /:year/movies/:movie_id/reviews/:id' do
    let!(:review) { create(:review, user: user, movie: movie, stars: 8, comment: 'Great movie!') }

    context 'when logged in as review owner' do
      before { sign_in(user) }

      it 'removes the rating while preserving comment' do
        patch "/2025/movies/#{movie.slug}/reviews/#{review.id}", params: {
          review: { stars: '', comment: 'Great movie!' }
        }

        review.reload
        expect(review.stars).to be_nil
        expect(review.comment).to eq('Great movie!')
      end

      it 'marks movie as unwatched when rating is removed' do
        patch "/2025/movies/#{movie.slug}/reviews/#{review.id}", params: {
          review: { stars: '', comment: 'Changed my mind' }
        }

        expect(response).to redirect_to(movies_path(year: 2025))
        expect(flash[:notice]).to include('Unwatched')
      end
    end
  end
end
