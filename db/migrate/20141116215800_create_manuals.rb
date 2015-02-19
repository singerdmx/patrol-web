class CreateManuals < ActiveRecord::Migration
  def change
    create_table :manuals do |t|
      t.text :entry

      t.timestamps
    end
  end
end
