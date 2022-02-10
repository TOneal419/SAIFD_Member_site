class CreateUsers < ActiveRecord::Migration[6.1]
  # def change
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :class_year
      t.integer :role_id
      t.integer :user_id

      t.timestamps
    end

    execute <<-SQL
      CREATE SEQUENCE users_user_id_seq START 1;
      ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;
      ALTER TABLE users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq');
    SQL
  end

  def self.down
    execute <<-SQL
      DROP SEQUENCE users_user_id_seq;
    SQL
  end
end
