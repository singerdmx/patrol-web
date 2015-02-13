require 'csv'

class CheckResult < ActiveRecord::Base
  belongs_to :check_session
  belongs_to :check_point

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |row|
        csv << row.attributes.values_at(*column_names)
      end
    end
  end

end
