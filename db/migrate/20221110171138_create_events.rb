class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string   :title
      t.text     :description
      t.string   :location
      t.string   :gc_event_id
      t.string   :gc_link
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
