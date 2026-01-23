require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  let!(:user) { create(:user, email: 'reviewer@example.com', password: 'password123') }
  let!(:category) { create(:category, name: 'Best Picture') }
  let!(:movie) { create(:movie, title: 'Reviewable Movie') }
  let!(:nomination) { create(:nomination, movie: movie, category: category, year: 2025) }

  before do
    visit signin_path
    fill_in 'Email', with: 'reviewer@example.com'
    fill_in 'Password', with: 'password123'
    click_button 'Sign In!'
  end

  describe 'adding a review' do
    it 'allows a logged in user to navigate to review form' do
      visit "/2025/movies/#{movie.slug}"

      click_link 'Watched!'

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

    it 'stores the exact datetime when creating a review' do
      watched_time = Time.zone.parse('2025-01-15 14:30')

      visit "/2025/movies/#{movie.slug}/reviews/new"

      find('input[value="8"]', visible: false).choose
      fill_in 'Date Watched', with: watched_time.strftime('%Y-%m-%dT%H:%M')
      click_button 'Mark as Watched'

      review = Review.last
      expect(review.watched_on).to be_within(1.minute).of(watched_time)
    end
  end

  describe 'updating a review' do
    let!(:review) { create(:review, user: user, movie: movie, stars: 7, watched_on: 2.days.ago) }

    it 'allows a user to update the watched datetime' do
      new_watched_time = Time.zone.parse('2025-01-20 18:45')

      visit edit_movie_review_path(movie, review, year: 2025)

      fill_in 'Date Watched', with: new_watched_time.strftime('%Y-%m-%dT%H:%M')
      click_button 'Update'

      expect(page).to have_content('Review updated')
      expect(review.reload.watched_on).to be_within(1.minute).of(new_watched_time)
    end
  end

  describe 'deleting a review' do
    let!(:review) { create(:review, user: user, movie: movie, stars: 7) }

    it 'allows a user to delete their review' do
      visit "/2025/movies/#{movie.slug}"

      click_button 'Unwatch!'

      expect(page).to have_content('Movie marked as Unwatched')
    end
  end
end
