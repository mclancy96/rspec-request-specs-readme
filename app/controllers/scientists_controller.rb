class ScientistsController < ApplicationController
  before_action :set_scientist, only: [:show, :update, :destroy]

  def index
    scientists = Scientist.all
    render json: scientists
  end

  def show
    render json: @scientist
  end

  def create
    scientist = Scientist.new(scientist_params)
    if scientist.save
      render json: scientist, status: :created
    else
      render json: { errors: scientist.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @scientist.update(scientist_params)
      render json: @scientist
    else
      render json: { errors: @scientist.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @scientist.destroy
    head :no_content
  end

  private

  def set_scientist
    @scientist = Scientist.find(params[:id])
  end

  def scientist_params
    params.require(:scientist).permit(:name, :field)
  end
end
