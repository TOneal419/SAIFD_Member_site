class Users < ActiveRecord::Migration[6.1]
  # def change
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :class_year
      t.integer :role_id
      t.string :report_rate
      t.integer :user_id

      t.timestamps
    end

    execute <<-SQL
      CREATE SEQUENCE users_user_id_seq START 1;
      ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;
      ALTER TABLE users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq');
      
      INSERT INTO users(email, first_name, last_name, class_year, role_id, report_rate, created_at, updated_at)
      VALUES ('wjmckinley@tamu.edu', 'Bill', 'McKinley', NULL, 2, 'Weekly', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
    SQL
  end

  def self.down
    execute <<-SQL
      DROP SEQUENCE users_user_id_seq;
    SQL
  end
end
