class AddResultAudioToCheckResult < ActiveRecord::Migration
  def change
    add_reference :check_results, :result_audio, index: true
  end
end
