class AddAttendTimeEndToAttendance < ActiveRecord::Migration[6.1]
  def change
    add_column :attendances, :attend_time_end, :time
  end
end
