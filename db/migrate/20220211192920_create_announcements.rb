# frozen_string_literal: true

class CreateAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :announcements do |t|
      t.integer :announcement_id
      t.string :title
      t.string :description
      t.datetime :posted_on
      t.integer :user_id
      t.integer :event_id, :null = true

      t.timestamps
    end
  end
end
