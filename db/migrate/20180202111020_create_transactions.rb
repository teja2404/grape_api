class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.text :details
      t.integer :account_id
      t.timestamps
    end
  end
end
