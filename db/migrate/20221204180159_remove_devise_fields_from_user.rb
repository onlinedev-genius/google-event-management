class RemoveDeviseFieldsFromUser < ActiveRecord::Migration[7.0]
  def change
    change_table(:users) do |t|
      t.remove :encrypted_password, type: :string
      t.remove :reset_password_token, type: :string
      t.remove :reset_password_sent_at, type: :datetime
      t.remove :remember_created_at, type: :datetime
    end
  end
end
