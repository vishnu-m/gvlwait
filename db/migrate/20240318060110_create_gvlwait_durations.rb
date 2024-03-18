class CreateGvlwaitDurations < ActiveRecord::Migration[7.1]
  def change
    create_table :gvlwait_durations do |t|
      t.float :wait_duration, null: false
      t.string :process_type, null: false
      t.integer :concurrency_level, null: false
      
      t.timestamps
    end
  end
end
