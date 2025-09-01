  describe "PENDING: PUT /results/:id" do
    it "replaces a result (PENDING)" do
      skip("Implement full replace for a result using PUT")
      # put "/results/#{result.id}", params: { result: { value: "New Value" } }
      # expect(response).to have_http_status(:ok)
    end
  end

  describe "PENDING: PATCH /results/:id" do
    it "partially updates a result (PENDING)" do
      skip("Implement partial update for a result using PATCH")
      # patch "/results/#{result.id}", params: { result: { value: "Updated Value" } }
      # expect(response).to have_http_status(:ok)
    end
  end

  describe "PENDING: DELETE /results/:id" do
    it "removes a result (PENDING)" do
      skip("Implement delete for a result")
      # delete "/results/#{result.id}"
      # expect(response).to have_http_status(:no_content)
    end
  end

  describe "PENDING: POST /experiments/:experiment_id/results" do
    it "creates a result for an experiment (PENDING)" do
      skip("Implement create for a result for an experiment")
      # post "/experiments/#{experiment.id}/results", params: { result: { value: "Test Value" } }
      # expect(response).to have_http_status(:created)
    end
  end

  describe "PENDING: GET /results/:id" do
    it "shows a result (PENDING)" do
      skip("Implement show for a result")
      # get "/results/#{result.id}"
      # expect(response).to have_http_status(:ok)
    end
  end

require 'rails_helper'

RSpec.describe "Results API", type: :request do
  let!(:scientist) { Scientist.create!(name: "Rosalind Franklin", field: "Chemistry") }
  let!(:experiment) { scientist.experiments.create!(title: "DNA Structure Analysis") }
  let!(:result) { experiment.results.create!(value: "Double Helix Observed") }

  describe "GET /results/:id" do
    it "returns a single result" do
      get "/results/#{result.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["value"]).to eq("Double Helix Observed")
    end
  end

  describe "POST /experiments/:experiment_id/results" do
    it "creates a result for an experiment" do
      expect {
        post "/experiments/#{experiment.id}/results", params: { result: { value: "Helix Confirmed" } }
      }.to change(Result, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid data" do
      post "/experiments/#{experiment.id}/results", params: { result: { value: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Value can't be blank")
    end
  end

  describe "PATCH /results/:id" do
    it "updates a result" do
      patch "/results/#{result.id}", params: { result: { value: "Updated Value" } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["value"]).to eq("Updated Value")
    end
  end

  describe "DELETE /results/:id" do
    it "deletes a result" do
      res = experiment.results.create!(value: "To Be Deleted")
      expect {
        delete "/results/#{res.id}"
      }.to change(Result, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET /experiments/:experiment_id/results" do
    it "returns all results for an experiment" do
      get "/experiments/#{experiment.id}/results"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to be >= 1
    end
  end
end
