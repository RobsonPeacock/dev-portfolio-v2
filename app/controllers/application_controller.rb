class ApplicationController < ActionController::API
  def index
    render json: {
      status: "online",
      version: "v1",
      message: "Welcome to my portfolio"
    }
  end
end
