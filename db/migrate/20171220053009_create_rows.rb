class CreateRows < ActiveRecord::Migration[5.1]
  def change
    create_table :rows do |t|
      t.references :table

      t.timestamps
    end
  end
end
