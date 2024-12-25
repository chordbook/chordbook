class RemovePasswordResetFields < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.remove :password_reset_token
      t.remove :password_reset_sent_at
    end
  end
end
