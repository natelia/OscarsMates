require 'rails_helper'

RSpec.describe "DesignSystems", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/design_system/index"
      expect(response).to have_http_status(:success)
    end
  end

end
