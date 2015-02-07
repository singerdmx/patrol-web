class FileController < ApplicationController
  def create
    # file = params[:files] for csv upload
    upload_img(params)

    render json: { success: true, id: 11 }.to_json, status: :created
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def upload_img(params)
    file = params[:file].read

    file_name = params[:file].original_filename
    # refer to http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method
    s3 = Aws::S3::Client.new(credentials: Settings::AWS_CREDENTIALS, region: Settings::AWS_REGION)
    response = s3.put_object(bucket: Settings::AWS_IMG_BUCKET, key: file_name, body: file, acl: 'public-read')
    url = response.instance_variable_get('@http_request').instance_variable_get('@endpoint').to_s
    puts url
  end
end
