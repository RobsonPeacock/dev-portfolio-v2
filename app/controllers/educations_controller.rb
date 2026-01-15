class EducationsController < ApplicationController
  before_action :set_about, only: [:index, :create]
  before_action :set_education, only: [:update, :destroy]

  def index
    @educations = @about.educations
    render json: @educations
  end

  def create
    @education = @about.educations.new(education_params)

    if @education.save
      render json: @education, status: :created
    else
      render json: { errors: @education.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @education.update(education_params)
      render json: @education
    else
      render json: { errors: @education.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Education not found" }, status: :not_found
  end

  def destroy
    if @education.destroy
      head :no_content
    else
      render json: { error: "Failed to delete education" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Education not found" }, status: :not_found
  end

  private

  def education_params
    params.require(:education).permit(:certification_url, :description, :end_date, 
                                      :field_of_study, :institution, :start_date, :title)
  end

  def set_education
    @education = Education.find(params[:id])
  end

  def set_about
    @about = About.first
  end
end