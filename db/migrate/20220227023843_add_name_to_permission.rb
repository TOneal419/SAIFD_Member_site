class AddNameToPermission < ActiveRecord::Migration[6.1]
  def change
    add_column :permissions, :name, :string
  end
end
