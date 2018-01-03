class CreateCostumers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.integer :branch_id
      t.boolean :status ,:default => true
      t.timestamps
    end
  end
end
