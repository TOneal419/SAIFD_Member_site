class RemoveAttendTimeStartFromAttendance < ActiveRecord::Migration[6.1]
  def change
    remove_column :attendances, :attend_time_start, :integer
  end
end
