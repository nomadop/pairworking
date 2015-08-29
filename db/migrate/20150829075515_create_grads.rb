class CreateGrads < ActiveRecord::Migration
  def change
    create_table :grads do |t|
      t.string :name, null: false
      t.string :role, null: false, default: 'DEV'
      t.string :photo

      t.timestamps null: false
    end
  end
end
