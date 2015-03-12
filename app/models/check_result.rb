require 'csv'

class CheckResult < ActiveRecord::Base
  include ModelHelper

  belongs_to :check_session
  belongs_to :check_point

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |row|
        r = ModelHelper::to_hash(row)
        csv << r.values
      end
    end
  end

end
