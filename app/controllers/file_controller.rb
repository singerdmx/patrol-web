class FileController < ApplicationController
  def create
    # file = params[:files] for csv upload
    id = upload_img(params)

    render json: { success: true, id: id }.to_json, status: :created
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def upload_img(params)
    file = params[:file].read

    file_name = params[:file].original_filename

    if Settings::STORE_IMAGE_LOCAL
      img_dir = File.join(File.dirname(__FILE__), '../assets/images/img')
      Dir.mkdir(img_dir) unless File.exists?(img_dir)

      File.open(File.join(img_dir, file_name), 'wb') do |f|
        f.write(file)
      end

      url = request.original_url[0..request.original_url.rindex('/')] + 'assets/img/' + file_name
      image = ResultImage.create!(name: file_name,url: url)
      return image.id
    end

    # refer to http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method
    s3 = Aws::S3::Client.new(credentials: Settings::AWS_CREDENTIALS, region: Settings::AWS_REGION)
    response = s3.put_object(bucket: Settings::AWS_IMG_BUCKET, key: file_name, body: file, acl: 'public-read')
    url = response.instance_variable_get('@http_request').instance_variable_get('@endpoint').to_s
    image = ResultImage.create!(name: file_name,url: url)
    image.id
  end
end
