# frozen_string_literal: true

class ApplicationController < ActionController::API
  def index
    render json: {
      text: 'Hello World from Backend!'
    }
  end
end
