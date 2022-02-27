class RemovePermissionIdFromPermission < ActiveRecord::Migration[6.1]
  def change
    remove_column :permissions, :permission_id, :integer
  end
end
