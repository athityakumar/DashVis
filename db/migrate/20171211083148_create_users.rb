class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :image
      t.string :email
      t.string :color_scheme
      t.timestamps
    end
  end
end
