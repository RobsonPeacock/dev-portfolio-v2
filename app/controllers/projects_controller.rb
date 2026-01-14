class ProjectsController < ApplicationController
  before_action :set_about, only: [:index, :create]
  before_action :set_project, only: [:update, :destroy]

  def index
    @projects = @about.projects
    render json: @projects
  end

  def create
    @project = @about.projects.new(project_params)

    if @project.save
      render json: @project, status: :created
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  def destroy
    if @project.destroy
      head :no_content
    else
      render json: { error: "Failed to delete project" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Project not found" }, status: :not_found
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def set_about
    @about = About.first
  end

  def project_params
    params.require(:project).permit(:description, :status, :title)
  end
end