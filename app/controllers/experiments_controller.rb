class ExperimentsController < ApplicationController
  before_action :set_experiment, only: [:show, :update, :destroy]
  before_action :set_scientist, only: [:index, :create]

  def index
    experiments = @scientist ? @scientist.experiments : Experiment.all
    render json: experiments
  end

  def show
    render json: @experiment
  end

  def create
    experiment = @scientist.experiments.build(experiment_params)
    if experiment.save
      render json: experiment, status: :created
    else
      render json: { errors: experiment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @experiment.update(experiment_params)
      render json: @experiment
    else
      render json: { errors: @experiment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @experiment.destroy
    head :no_content
  end

  private

  def set_experiment
    @experiment = Experiment.find(params[:id])
  end

  def set_scientist
    @scientist = Scientist.find(params[:scientist_id]) if params[:scientist_id]
  end

  def experiment_params
    params.require(:experiment).permit(:title)
  end
end
