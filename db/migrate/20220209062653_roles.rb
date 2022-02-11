class Roles < ActiveRecord::Migration[6.1]
  def self.up
    create_table :roles do |t|
      t.integer :role_id
      t.boolean :is_officer
      t.boolean :is_admin
      t.string :title

      t.timestamps
    end

    # by default, user role will be 0
    execute <<-SQL
      INSERT INTO roles(role_id, is_officer, is_admin, title, created_at, updated_at) VALUES (0, false, false, 'User', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    SQL
  end

  def self.down
    execute <<-SQL
      DELETE FROM roles WHERE role_id=0;
    SQL
  end
end