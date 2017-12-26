class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :tables do |t|
      t.string :name
      t.text   :description
      t.references :user

      t.timestamps
    end
  end
end
