class CreateResultAudios < ActiveRecord::Migration
  def change
    create_table :result_audios do |t|
      t.string :name
      t.text :url

      t.timestamps
    end
  end
end
