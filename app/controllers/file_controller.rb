class FileController < ApplicationController
  def create
    # file = params[:files] for csv upload
    fail "no file in params #{params.inspect}" unless params[:file] || params[:files]
    id = upload_media(params) if params[:file]
    render json: { success: true, id: id }.to_json, status: :created
  rescue Exception => e
    Rails.logger.error("Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}")
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  private

  def upload_media(params)
    file = params[:file].read

    file_name = params[:file].original_filename
    type = file_name.split('.')[-2]

    fail "Invalid file_name #{file_name} of type #{type}" unless type == 'img' || type == 'audio'

    if Settings::STORE_MEDIA_LOCAL
      media_dir = File.join(File.dirname(__FILE__), "../assets/images/#{type}")
      Dir.mkdir(media_dir) unless File.exists?(media_dir)

      File.open(File.join(media_dir, file_name), 'wb') do |f|
        f.write(file)
      end

      url = request.original_url[0..request.original_url.rindex('/')] + "assets/#{type}/" + file_name
      media = ResultImage.create!(name: file_name,url: url) if type == 'img'
      media = ResultAudio.create!(name: file_name,url: url) if type == 'audio'
      return media.id
    end

    # refer to http://docs.aws.amazon.com/sdkforruby/api/Aws/S3/Client.html#put_object-instance_method
    s3 = Aws::S3::Client.new(credentials: Settings::AWS_CREDENTIALS, region: Settings::AWS_REGION)
    response = s3.put_object(bucket: "patrol-#{type}", key: file_name, body: file, acl: 'public-read')
    url = response.instance_variable_get('@http_request').instance_variable_get('@endpoint').to_s

    media = ResultImage.create!(name: file_name,url: url) if type == 'img'
    media = ResultAudio.create!(name: file_name,url: url) if type == 'audio'
    media.id
  end
end
