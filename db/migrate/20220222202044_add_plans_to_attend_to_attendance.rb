class AddPlansToAttendToAttendance < ActiveRecord::Migration[6.1]
  def change
    add_column :attendances, :plans_to_attend, :boolean
  end
end
