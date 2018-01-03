class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.integer :customer_id
      t.boolean :status, :default => true
      t.float :balance, :default => 0.00
      t.string :account_type
      t.timestamps
    end
  end
end
