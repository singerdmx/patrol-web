class AddSubmitterToCheckSessions < ActiveRecord::Migration
  def change
    add_column :check_sessions, :submitter, :string
  end
end
