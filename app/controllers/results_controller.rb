class ResultsController < ApplicationController
  before_action :set_result, only: [:show, :update, :destroy]
  before_action :set_experiment, only: [:index, :create]

  def index
    results = @experiment ? @experiment.results : Result.all
    render json: results
  end

  def show
    render json: @result
  end

  def create
    result = @experiment.results.build(result_params)
    if result.save
      render json: result, status: :created
    else
      render json: { errors: result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @result.update(result_params)
      render json: @result
    else
      render json: { errors: @result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @result.destroy
    head :no_content
  end

  private

  def set_result
    @result = Result.find(params[:id])
  end

  def set_experiment
    @experiment = Experiment.find(params[:experiment_id]) if params[:experiment_id]
  end

  def result_params
    params.require(:result).permit(:value)
  end
end
