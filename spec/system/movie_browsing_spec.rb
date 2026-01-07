require 'rails_helper'

RSpec.describe 'Movie Browsing', type: :system do
  let!(:category) { create(:category, name: 'Best Picture') }
  let!(:movie) { create(:movie, title: 'Test Movie') }
  let!(:nomination) { create(:nomination, movie: movie, category: category, year: 2025) }

  describe 'viewing movies list' do
    it 'displays movies for the year' do
      visit '/2025/movies'

      expect(page).to have_content('Test Movie')
    end
  end

  describe 'viewing movie details' do
    it 'displays movie information' do
      visit "/2025/movies/#{movie.slug}"

      expect(page).to have_content('Test Movie')
    end
  end

  describe 'filtering movies' do
    let!(:watched_user) { create(:user) }
    let!(:review) { create(:review, movie: movie, user: watched_user) }

    before do
      visit signin_path
      fill_in 'Email', with: watched_user.email
      fill_in 'Password', with: 'password'
      click_button 'Sign In'
    end

    it 'can filter by watched status' do
      visit '/2025/movies?filter=watched'

      expect(page).to have_content('Test Movie')
    end
  end
end
