class RemoveAnnouncementIdFromAnnouncement < ActiveRecord::Migration[6.1]
  def change
    remove_column :announcements, :announcement_id, :integer
  end
end
