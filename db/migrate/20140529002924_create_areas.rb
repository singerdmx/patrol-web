class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.references :subfactory, index: true

      t.timestamps
    end
  end
end
