class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows, id: :uuid do |t|
      t.uuid :follower_id, null: false
      t.uuid :followed_id, null: false

      t.timestamps
    end

    add_index :follows, [:follower_id, :followed_id], unique: true
  end
end
