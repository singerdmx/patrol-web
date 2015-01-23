class FileController < ApplicationController
  def create
    # file = params[:files] for csv upload
    file = params[:file].read

    file_name = "/Users/xyao/Downloads/" + params[:file].original_filename
    puts file_name
    File.open(file_name, 'wb') do |f|
      f.write(file)
    end
    render json: { success: true, id: 11, file: params[:file].original_filename }.to_json, status: :created
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end
end
