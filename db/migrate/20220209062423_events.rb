class Events < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.integer :event_id
      t.string :title
      t.string :description
      t.date :date

      t.timestamps
    end
  end
end
