class CreateAccountActivationCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :account_activation_codes do |t|
      t.integer :user_id
      t.string :code

      t.timestamps
    end
  end
end
