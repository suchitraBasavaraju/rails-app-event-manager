class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :user_id
      t.string :event_type

      t.timestamps
    end
  end
end
