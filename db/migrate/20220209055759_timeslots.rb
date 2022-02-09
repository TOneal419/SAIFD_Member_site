class Timeslots < ActiveRecord::Migration[6.1]
  def change
    create_table :timeslots do |t|
      t.integer :timeslot_id
      t.integer :attendance_id
      t.time :attend_time_start
      t.time :attend_time_end
      t.time :event_time_start
      t.time :event_time_end

      t.timestamps
    end
  end
end
