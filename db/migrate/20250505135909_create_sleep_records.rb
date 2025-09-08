class CreateSleepRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_records, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: true
      t.datetime :clock_in, null: false
      t.datetime :clock_out
      t.integer :duration_s

      t.timestamps
    end

    add_index :sleep_records, [:user_id, :clock_in]
    add_index :sleep_records, [:user_id, :clock_out]
    add_index :sleep_records, :duration_s
    add_index :sleep_records, [:user_id, :created_at]

    # this query used for check if the user has an active sleep record
    add_index :sleep_records, :user_id, name: 'index_sleep_records_active_per_user', unique: true, where: 'clock_out IS NULL'
  end
end
