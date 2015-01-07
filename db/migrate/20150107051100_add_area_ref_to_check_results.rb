class AddAreaRefToCheckResults < ActiveRecord::Migration
  def change
    add_reference :check_results, :area, index: true
  end
end
