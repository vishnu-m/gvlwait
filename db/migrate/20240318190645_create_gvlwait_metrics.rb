class CreateGvlwaitMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :gvlwait_metrics do |t|
      t.string :request_id, null: false
      t.float :gvl_wait_time, null: false
      t.float :processing_time, null: false
      t.string :process_type, null: false
      t.integer :concurrency_level, null: false

      t.timestamps
    end
  end
end
