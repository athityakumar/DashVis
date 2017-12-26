json.extract! account, :id, :name, :username, :email, :password, :confirm_password, :created_at, :updated_at
json.url account_url(account, format: :json)
