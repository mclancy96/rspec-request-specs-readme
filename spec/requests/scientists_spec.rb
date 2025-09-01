  describe "PENDING: PUT /scientists/:id" do
    it "replaces a scientist (PENDING)" do
      skip("Implement full replace for a scientist using PUT")
      # put "/scientists/#{scientist.id}", params: { scientist: { name: "New Name", field: "New Field" } }
      # expect(response).to have_http_status(:ok)
    end
  end

  describe "PENDING: PATCH /scientists/:id" do
    it "partially updates a scientist (PENDING)" do
      skip("Implement partial update for a scientist using PATCH")
      # patch "/scientists/#{scientist.id}", params: { scientist: { field: "Updated Field" } }
      # expect(response).to have_http_status(:ok)
    end
  end

  describe "PENDING: DELETE /scientists/:id" do
    it "removes a scientist (PENDING)" do
      skip("Implement delete for a scientist")
      # delete "/scientists/#{scientist.id}"
      # expect(response).to have_http_status(:no_content)
    end
  end

  describe "PENDING: POST /scientists" do
    it "creates a scientist (PENDING)" do
      skip("Implement create for a scientist")
      # post "/scientists", params: { scientist: { name: "Test", field: "Test Field" } }
      # expect(response).to have_http_status(:created)
    end
  end

  describe "PENDING: GET /scientists" do
    it "lists all scientists (PENDING)" do
      skip("Implement listing all scientists")
      # get "/scientists"
      # expect(response).to have_http_status(:ok)
    end
  end

require 'rails_helper'

RSpec.describe "Scientists API", type: :request do
  let!(:scientist) { Scientist.create!(name: "Ada Lovelace", field: "Mathematics") }

  describe "GET /scientists" do
    it "returns a list of scientists" do
      get "/scientists"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["name"]).to eq("Ada Lovelace")
    end
  end

  describe "GET /scientists/:id" do
    it "returns a single scientist" do
      get "/scientists/#{scientist.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["field"]).to eq("Mathematics")
    end
  end

  describe "POST /scientists" do
    it "creates a new scientist" do
      expect {
        post "/scientists", params: { scientist: { name: "Marie Curie", field: "Physics" } }
      }.to change(Scientist, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid data" do
      post "/scientists", params: { scientist: { name: "", field: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
    end
  end

  describe "PATCH /scientists/:id" do
    it "updates a scientist" do
      patch "/scientists/#{scientist.id}", params: { scientist: { field: "Computer Science" } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["field"]).to eq("Computer Science")
    end
  end

  describe "DELETE /scientists/:id" do
    it "deletes a scientist" do
      expect {
        delete "/scientists/#{scientist.id}"
      }.to change(Scientist, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET /scientists/:id for non-existent scientist" do
    it "returns not found" do
      get "/scientists/99999"
      expect(response).to have_http_status(:not_found).or have_http_status(:unprocessable_entity)
    end
  end

  describe "PENDING: GET /scientists/:id/experiments" do
    it "returns all experiments for a scientist (PENDING)" do
      skip("Implement listing experiments for a scientist")
      # get "/scientists/#{scientist.id}/experiments"
      # expect(response).to have_http_status(:ok)
    end
  end

  describe "PENDING: POST /scientists/:id/experiments" do
    it "creates an experiment for a scientist (PENDING)" do
      skip("Implement creating experiment for a scientist")
      # post "/scientists/#{scientist.id}/experiments", params: { experiment: { title: "Test Experiment" } }
      # expect(response).to have_http_status(:created)
    end
  end
end
