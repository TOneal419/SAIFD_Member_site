# frozen_string_literal: true

class Attendances < ActiveRecord::Migration[6.1]
  def change
    create_table :attendances do |t|
      t.integer :event_id
      t.integer :user_id
      t.time :attend_time_start
      t.time :attend_time_end

      t.timestamps
    end
  end
end
