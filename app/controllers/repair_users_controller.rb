class RepairUsersController < ApplicationController
  include RepairUsersHelper

  def show
    @show_full_view = show_full_view?
  end

end
