class CreateData < ActiveRecord::Migration[5.1]
  def change
    create_table :data do |t|
      t.string :value
      t.references :row
      t.references :column

      t.timestamps
    end
  end
end
