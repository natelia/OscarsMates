require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  let!(:user) { create(:user, email: 'reviewer@example.com', password: 'password123') }
  let!(:category) { create(:category, name: 'Best Picture') }
  let!(:movie) { create(:movie, title: 'Reviewable Movie') }
  let!(:nomination) { create(:nomination, movie: movie, category: category, year: 2025) }

  before do
    page.driver.post create_session_path, { email: user.email, password: 'password123' }
  end

  describe 'adding a review' do
    it 'allows a logged in user to navigate to review form' do
      visit "/2025/movies/#{movie.slug}"

      click_link 'Watched', match: :first

      expect(page).to have_content('Reviewable Movie')
      expect(page).to have_button('Mark as Watched')
    end

    it 'allows a logged in user to create a review' do
      visit "/2025/movies/#{movie.slug}/reviews/new"

      find('input[value="8"]', visible: false).choose
      fill_in 'Date Watched', with: Time.current.strftime('%Y-%m-%dT%H:%M')
      click_button 'Mark as Watched'

      expect(page).to have_content('Thanks for your review')
    end

    it 'stores the date when creating a review' do
      skip 'Custom date picker requires JavaScript driver'
      watched_date = Date.new(2025, 1, 15)

      visit "/2025/movies/#{movie.slug}/reviews/new"

      find('input[value="8"]', visible: false).choose
      fill_in 'Date Watched', with: watched_date.strftime('%Y-%m-%d')
      click_button 'Mark as Watched'

      review = Review.last
      expect(review.watched_on.to_date).to eq(watched_date)
    end
  end

  describe 'updating a review' do
    let!(:review) { create(:review, user: user, movie: movie, stars: 7, watched_on: 2.days.ago) }

    it 'allows a user to update the watched date' do
      skip 'Custom date picker requires JavaScript driver'
      new_watched_date = Date.new(2025, 1, 20)

      visit edit_movie_review_path(movie, review, year: 2025)

      fill_in 'Date Watched', with: new_watched_date.strftime('%Y-%m-%d')
      click_button 'Update'

      expect(page).to have_content('Review updated')
      expect(review.reload.watched_on.to_date).to eq(new_watched_date)
    end
  end

  describe 'deleting a review' do
    let!(:review) { create(:review, user: user, movie: movie, stars: 7) }

    it 'allows a user to delete their review' do
      visit edit_movie_review_path(movie, review, year: 2025)

      click_button 'Unwatch!'

      expect(page).to have_content('Movie marked as Unwatched')
    end
  end
end
