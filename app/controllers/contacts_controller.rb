class ContactsController < ApplicationController
  include ApplicationHelper

  # GET /contacts.json
  def index
    contacts = Contact.all
    contacts.map do |c|
      to_hash(c)
    end

    if stale?(etag: contacts)
      render json: contacts.to_json
    else
      head :not_modified
    end
  end
end
