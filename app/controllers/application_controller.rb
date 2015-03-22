require_relative '../../app/config/settings'

class ApplicationController < ActionController::Base
  include RbConfig

  # This is our new function that comes before Devise's one
  before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

  #before_action :authenticate,     only: [:index, :new, :create, :show, :edit, :update, :destroy]
  after_filter :set_csrf_header, only: [:new, :create]

  #rescue_from Exception do |e|
  #  render json: {:message=> e.to_s}.to_json, status: :internal_server_error
  #end

  protected

  def set_csrf_header
    response.headers['X-CSRF-Token'] = form_authenticity_token
  end

  private

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

  def convert_check_time(params)
    unless params[:check_time].nil?
      unless params[:check_time].include?('..') && params[:check_time].split('..').size == 2
        fail "Invalid check_time param #{params[:check_time]}"
      end

      time_window = params[:check_time].split('..')
      params[:check_time] = Time.at(time_window[0].to_i).to_datetime..Time.at(time_window[1].to_i).to_datetime
    end

    params
  end

  # go through json object, remove 'tombstone'=false
  # delete object that has 'tombstone'=true
  def filter_out_tombstone(json)
    if json.is_a?(Array)
      json.select do |j|
        !j.is_a?(Hash) or !j['tombstone']
      end.map do |j|
        filter_out_tombstone(j)
      end
    elsif json.is_a?(Hash)
      json.delete('tombstone')
      json.delete(:tombstone)
      json.each do |k,v|
        json[k] = filter_out_tombstone(v)
      end
      json
    else
      json
    end
  end

  def create_dummy_asset(params)
    Rails.logger.info("Creating dummy asset")
    Asset.create({
                   barcode: params[:barcode],
                   name: params[:name],
                   description: params[:description]
                 })
  end

  def delete_dummy_asset(p, new_asset_id)
    return if p.asset_id == new_asset_id

    dummy_asset = Asset.find(p.asset_id)
    return unless dummy_asset and dummy_asset.barcode == p.barcode and
      dummy_asset.name == p.name and dummy_asset.description == p.description

    Rails.logger.info("Deleting dummy asset")
    dummy_asset.update_attributes(tombstone: true)
  end

end
