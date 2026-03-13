class AboutController < ApplicationController
  before_action :set_about

  def index
    render json: @about
  end

  def update
    if @about.update(about_params)
      render json: @about
    else
      render json: { errors: @about.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_about
    @about = About.first
  end

  def about_params
    params.require(:about).permit(:bio, :location, :name, :profile_image_url, :tagline)
  end
end