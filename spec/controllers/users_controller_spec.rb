require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    it "returns a successful response" do
      user = User.create(name: "Admin", email: "admin@example.com", password: "password")
      session[:user_id] = user.id
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end