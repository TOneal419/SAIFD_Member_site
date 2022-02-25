class AddEventIdToAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :event_id, :integer
  end
end
