class AddEmailVerificationTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :email_verification_token_digest
    end
  end
end
