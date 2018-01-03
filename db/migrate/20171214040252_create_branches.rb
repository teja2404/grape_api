class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|
      t.string :branch_name

      t.timestamps
    end
  end
end
