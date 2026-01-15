class WorkExperiencesController < ApplicationController
  before_action :set_about, only: [:index, :create]
  before_action :set_work_experience, only: [:update, :destroy]

  def index
    @work_experiences = @about.work_experiences
    render json: @work_experiences
  end

  def create
    @work_experiences = @about.work_experiences.new(work_experiences_params)

    if @work_experiences.save
      render json: @work_experiences, status: :created
    else
      render json: { errors: @work_experiences.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @work_experience.update(work_experiences_params)
      render json: @work_experience
    else
      render json: { errors: @work_experience.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Work Experience not found" }, status: :not_found
  end

  def destroy
    if @work_experience.destroy
      head :no_content
    else
      render json: { error: "Failed to delete work experience" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Work Experience not found" }, status: :not_found
  end

  private

  def set_work_experience
    @work_experience = WorkExperience.find(params[:id])
  end

  def set_about
    @about = About.first
  end

  def work_experiences_params
    params.require(:work_experiences).permit(:company, :description, 
                                            :end_date, :role, :start_date)
  end
end