class CreatePermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :permissions do |t|
      t.integer :permission_id
      t.string :title
      t.boolean :is_admin
      t.boolean :create_modify_events
      t.boolean :create_modify_announcements
      t.boolean :view_all_attendances

      t.timestamps
    end
  end
end
