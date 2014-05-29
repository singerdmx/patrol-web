class CreateSubfactories < ActiveRecord::Migration
  def change
    create_table :subfactories do |t|
      t.string :name
      t.references :factory, index: true

      t.timestamps
    end
  end
end
