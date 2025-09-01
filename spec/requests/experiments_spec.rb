  describe "PENDING: PUT /experiments/:id" do
    it "replaces an experiment (PENDING)" do
      skip("Implement full replace for an experiment using PUT")
      # put "/experiments/#{experiment.id}", params: { experiment: { title: "New Title" } }
      # expect(response).to have_http_status(:ok)
    end
  end

  describe "PENDING: PATCH /experiments/:id" do
    it "partially updates an experiment (PENDING)" do
      skip("Implement partial update for an experiment using PATCH")
      # patch "/experiments/#{experiment.id}", params: { experiment: { title: "Updated Title" } }
      # expect(response).to have_http_status(:ok)
    end
  end

  describe "PENDING: DELETE /experiments/:id" do
    it "removes an experiment (PENDING)" do
      skip("Implement delete for an experiment")
      # delete "/experiments/#{experiment.id}"
      # expect(response).to have_http_status(:no_content)
    end
  end

  describe "PENDING: POST /scientists/:scientist_id/experiments" do
    it "creates an experiment for a scientist (PENDING)" do
      skip("Implement create for an experiment for a scientist")
      # post "/scientists/#{scientist.id}/experiments", params: { experiment: { title: "Test Experiment" } }
      # expect(response).to have_http_status(:created)
    end
  end

  describe "PENDING: GET /experiments/:id" do
    it "shows an experiment (PENDING)" do
      skip("Implement show for an experiment")
      # get "/experiments/#{experiment.id}"
      # expect(response).to have_http_status(:ok)
    end
  end

require 'rails_helper'

RSpec.describe "Experiments API", type: :request do
  let!(:scientist) { Scientist.create!(name: "Jane Goodall", field: "Primatology") }
  let!(:experiment) { scientist.experiments.create!(title: "Chimpanzee Social Behavior") }

  describe "GET /experiments/:id" do
    it "returns a single experiment" do
      get "/experiments/#{experiment.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("Chimpanzee Social Behavior")
    end
  end

  describe "POST /scientists/:scientist_id/experiments" do
    it "creates an experiment for a scientist" do
      expect {
        post "/scientists/#{scientist.id}/experiments", params: { experiment: { title: "Tool Use Study" } }
      }.to change(Experiment, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns errors for invalid data" do
      post "/scientists/#{scientist.id}/experiments", params: { experiment: { title: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
    end
  end

  describe "PATCH /experiments/:id" do
    it "updates an experiment" do
      patch "/experiments/#{experiment.id}", params: { experiment: { title: "Updated Title" } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("Updated Title")
    end
  end

  describe "DELETE /experiments/:id" do
    it "deletes an experiment" do
      exp = scientist.experiments.create!(title: "To Be Deleted")
      expect {
        delete "/experiments/#{exp.id}"
      }.to change(Experiment, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "GET /scientists/:scientist_id/experiments" do
    it "returns all experiments for a scientist" do
      get "/scientists/#{scientist.id}/experiments"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to be >= 1
    end
  end

  describe "PENDING: GET /experiments/:id/results" do
    it "returns all results for an experiment (PENDING)" do
      skip("Implement listing results for an experiment")
      # get "/experiments/#{experiment.id}/results"
      # expect(response).to have_http_status(:ok)
    end
  end
end
