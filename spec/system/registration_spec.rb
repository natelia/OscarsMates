require 'rails_helper'

RSpec.describe 'User Registration', type: :system do
  describe 'signing up' do
    it 'displays the signup form' do
      visit signup_path

      expect(page).to have_content('Sign Up')
      expect(page).to have_field('Name')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
    end

    it 'allows a new user to register' do
      visit signup_path

      fill_in 'name', with: 'Test User'
      fill_in 'email', with: 'testuser@example.com'
      fill_in 'password', with: 'password123'
      fill_in 'password_confirmation', with: 'password123'
      click_button 'Sign up!'

      expect(page).to have_content('Thanks for signing up!')
    end

    it 'shows validation errors for invalid registration' do
      visit signup_path

      fill_in 'name', with: ''
      fill_in 'email', with: 'invalid'
      fill_in 'password', with: 'short'
      fill_in 'password_confirmation', with: 'different'
      click_button 'Sign up!'

      expect(page).to have_content("can't be blank")
    end
  end
end
