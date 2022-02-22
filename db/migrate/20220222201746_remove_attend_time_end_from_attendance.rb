class RemoveAttendTimeEndFromAttendance < ActiveRecord::Migration[6.1]
  def change
    remove_column :attendances, :attend_time_end, :integer
  end
end
