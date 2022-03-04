# frozen_string_literal: true

class Users < ActiveRecord::Migration[6.1]
  # def change
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :report_rate
      t.integer :class_year
      t.integer :permission_id

      t.timestamps
    end

    # TODO: create default admin acc somehow
  end
end
