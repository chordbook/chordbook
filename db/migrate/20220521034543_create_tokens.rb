class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :access_tokens do |t|
      t.string :jti
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :expire_at
      t.datetime :invalidated_at
      t.string :refresh_token_digest, index: {unique: true}
      t.string :remote_ip
      t.string :user_agent

      t.timestamps
    end
    add_index :access_tokens, :jti, unique: true
  end
end
