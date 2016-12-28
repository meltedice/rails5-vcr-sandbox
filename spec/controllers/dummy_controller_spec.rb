require 'rails_helper'

RSpec.describe DummyController, type: :controller do

  describe "GET #a" do
    it "returns http success" do
      get :a
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #b" do
    it "returns http success" do
      get :b
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #c" do
    it "returns http success" do
      get :c
      expect(response).to have_http_status(:success)
    end
  end

end
