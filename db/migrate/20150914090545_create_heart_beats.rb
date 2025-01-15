class CreateHeartBeats < ActiveRecord::Migration[4.2]
  def change
    create_table :heart_beats do |t|
      t.column 'user_id',:integer
      t.column 'ip_address',:string

      t.timestamps
    end
  end
end
