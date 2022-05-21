class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :jti
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :expires_at
      t.datetime :blocked_at

      t.timestamps
    end
    add_index :tokens, :jti, unique: true
  end
end
