class CreateRepairReports < ActiveRecord::Migration
  def change
    create_table :repair_reports do |t|
      t.string :kind
      t.string :code
      t.string :description
      t.string :content
      t.boolean :stopped
      t.boolean :production_line_stopped
      t.timestamp :created_at
      t.timestamp :updated_at

      t.timestamps
    end
  end
end
