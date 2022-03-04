# frozen_string_literal: true

class Events < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.date :date
      t.time :event_time_start
      t.time :event_time_end

      t.timestamps
    end
  end
end
