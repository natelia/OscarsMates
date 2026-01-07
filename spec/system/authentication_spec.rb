require 'rails_helper'

RSpec.describe 'User Authentication', type: :system do
  let!(:user) { create(:user, email: 'user@example.com', password: 'password123') }

  describe 'signing in' do
    it 'allows a user to sign in with valid credentials' do
      visit signin_path

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password123'
      click_button 'Sign In!'

      expect(page).to have_content('Logged in successfully')
    end

    it 'shows error with invalid credentials' do
      visit signin_path

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign In!'

      expect(page).to have_content('Invalid email/password combination')
    end
  end

  describe 'signing out' do
    before do
      visit signin_path
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password123'
      click_button 'Sign In!'
    end

    it 'allows a user to sign out' do
      click_button 'Sign Out'

      expect(page).to have_content('Logged out successfully')
    end
  end
end
