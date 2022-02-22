class RemoveUserIdFromAnnouncement < ActiveRecord::Migration[6.1]
  def change
    remove_column :announcements, :user_id, :string
  end
end
