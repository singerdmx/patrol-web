class ContactsController < ApplicationController
  include ApplicationHelper

  # GET /contacts.json
  def index
    contacts = Contact.all
    if params[:ui] == 'true'
      contacts = contacts.map do |c|
        [c.id, c.name, c.email]
      end
    else
      contacts = contacts.map do |c|
        to_hash(c, true)
      end
    end

    if stale?(etag: contacts)
      render json: contacts.to_json
    else
      head :not_modified
    end
  end

  # POST /contacts.json
  def create
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    AlertMailer.alert_email(current_user).deliver

    Contact.create! do |c|
      c.name = params[:name]
      c.email = params[:email]
    end

    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def destroy
    unless current_user.is_admin?
      render json: {message: '您没有权限进行本次操作！'}.to_json, status: :unauthorized
      return
    end

    Contact.find(params[:id]).destroy
    render json: { success: true }.to_json, status: :ok
  rescue Exception => e
    Rails.logger.error("Encountered an error while deleting contact #{params.inspect}: #{e}")
    render json: {message: e.to_s}.to_json, status: :unprocessable_entity
  end
end
