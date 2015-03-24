class ChangeAreaIdNotNullableInResults < ActiveRecord::Migration
  def change
    change_column_null(:check_results, :area_id, false )
  end
end
