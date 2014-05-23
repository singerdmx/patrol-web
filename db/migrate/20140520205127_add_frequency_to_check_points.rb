class AddFrequencyToCheckPoints < ActiveRecord::Migration
  def change
    add_column :check_points, :frequency, :integer , :default => 24
  end
end
