class AddActiveToGrads < ActiveRecord::Migration
  def change
    add_column :grads, :active, :boolean, default: true
  end
end
