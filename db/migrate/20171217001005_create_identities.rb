class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :color_scheme
      t.string :provider
      t.string :uid
      t.string :image
      t.string :oauth_token
      t.datetime :oauth_expires_at
      t.references :user
      t.timestamps
    end
  end
end
