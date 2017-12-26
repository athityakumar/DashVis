class CreateColumns < ActiveRecord::Migration[5.1]
  def change
    create_table :columns do |t|
      t.string :name
      t.string :datatype

      t.references :table
      t.timestamps
    end
  end
end
