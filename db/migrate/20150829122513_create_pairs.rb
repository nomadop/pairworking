class CreatePairs < ActiveRecord::Migration
  def change
    create_table :pairs do |t|
      t.integer :grad1_id
      t.integer :grad2_id
      t.string :pair_name, null: false
      t.integer :pair_time, default: 0
      t.integer :status, default: 0
      t.integer :story

      t.timestamps null: false
      t.index :pair_name, unique: true
    end
  end
end
