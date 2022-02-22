class AddUserIdToAnnouncement < ActiveRecord::Migration[6.1]
  def change
    add_column :announcements, :user_id, :integer
  end
end
