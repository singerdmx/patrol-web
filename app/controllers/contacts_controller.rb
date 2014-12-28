class ContactsController < ApplicationController
  include ApplicationHelper

  # GET /contacts.json
  def index
    contacts = Contact.all
    if params[:ui] == 'true'
      contacts = contacts.map do |c|
        [c.id, c.name, c.email]
      end
    end

    if stale?(etag: contacts)
      render json: contacts.to_json
    else
      head :not_modified
    end
  end
end
