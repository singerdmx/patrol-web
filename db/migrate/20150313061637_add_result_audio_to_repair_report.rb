class AddResultAudioToRepairReport < ActiveRecord::Migration
  def change
    add_reference :repair_reports, :result_audio, index: true
  end
end
