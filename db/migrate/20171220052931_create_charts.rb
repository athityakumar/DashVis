class CreateCharts < ActiveRecord::Migration[5.1]
  def change
    create_table :charts do |t|
      t.string :name
      t.string :type
      t.string :category_column
      t.string :weight_column
      t.references :table

      t.timestamps
    end
  end
end
