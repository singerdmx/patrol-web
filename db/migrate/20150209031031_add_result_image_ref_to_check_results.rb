class AddResultImageRefToCheckResults < ActiveRecord::Migration
  def change
    add_reference :check_results, :result_image, index: true
  end
end
