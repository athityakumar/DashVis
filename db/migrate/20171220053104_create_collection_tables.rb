class CreateCollectionTables < ActiveRecord::Migration[5.1]
  def change
    create_table :collection_tables do |t|
      t.references :collection
      t.references :table

      t.timestamps
    end
  end
end
