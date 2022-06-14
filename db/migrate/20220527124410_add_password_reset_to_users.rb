class AddPasswordResetToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
    end
  end
end
