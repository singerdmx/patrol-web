class CreateResultImages < ActiveRecord::Migration
  def change
    create_table :result_images do |t|
      t.string :name
      t.text :url

      t.timestamps
    end
  end
end
