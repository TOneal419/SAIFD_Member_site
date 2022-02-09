class Roles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.integer :role_id
      t.boolean :is_officer
      t.boolean :is_admin
      t.string :title

      t.timestamps
    end
  end
end
