class FileController < ApplicationController
  def create
    file = params[:files]
    render json: { success: true, file: file.first.original_filename }.to_json, status: :ok
  end
end
