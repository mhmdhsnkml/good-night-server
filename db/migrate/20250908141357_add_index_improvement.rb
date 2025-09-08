class AddIndexImprovement < ActiveRecord::Migration[7.1]
  def change
    # this query is used for get friends' sleep records
    add_index :sleep_records, [:user_id, :duration_s, :created_at], name: 'idx_sleep', where: 'clock_out IS NOT NULL AND duration_s IS NOT NULL'
  end
end
