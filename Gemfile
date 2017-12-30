source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.4.1"

gem 'rails', '~> 5.1.1'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'mysql2', '>= 0.3.13', '< 0.5'
gem 'pg'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', '~> 0.9.4', require: false
gem 'unidecoder'
gem 'bcrypt'
gem 'daru'
gem 'daru-io'
# gem 'activerecord'
gem 'jsonpath'
gem 'csv'
gem 'spreadsheet'

gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-github'

gem 'dotenv-rails'
gem 'jquery-rails'

gem 'yui-compressor'
gem 'htmlcompressor'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end
group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'high_voltage'
# gem 'jquery-rails'
# gem 'jquery-datatables'
group :development do
  gem 'better_errors'
  gem 'rails_layout'
  gem 'spring-commands-rspec'
end
group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
end
group :test do
  gem 'database_cleaner'
  gem 'launchy'
end
