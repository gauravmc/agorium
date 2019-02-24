class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers do |t|
      t.string :email, limit: 255, null: false
      t.boolean :email_verified, default: false
      t.string :verification_digest
      t.datetime :verified_at

      t.timestamps
    end
    add_index :subscribers, :email, unique: true
  end
end
