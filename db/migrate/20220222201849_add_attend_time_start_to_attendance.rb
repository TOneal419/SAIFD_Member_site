class AddAttendTimeStartToAttendance < ActiveRecord::Migration[6.1]
  def change
    add_column :attendances, :attend_time_start, :time
  end
end
