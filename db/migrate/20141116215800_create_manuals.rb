class CreateManuals < ActiveRecord::Migration
  def change
    create_table :manuals do |t|
      t.text :entry
    end
  end
end
