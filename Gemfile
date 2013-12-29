source 'https://rubygems.org'

gem 'minitest-rails'


gem 'sync'
gem 'faye'
gem 'thin', require: false 

group :test do
  gem 'hirb'
  gem 'simplecov', :require => false
end

group :development do
  gem 'sextant'
  gem "rails-erd"
end

#extends rails logging and fixes assets to be served statically
gem 'rails_12factor' 

#makes playlist voteable
gem 'thumbs_up'


# Omniauth rdio authentication
gem 'omniauth-rdio'

# figaro for keeping ENV variables safe
gem "figaro"

# oauth...for further auhentications
gem 'oauth'

#rdio
gem 'rdio'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'


# Better errors in the browser
gem 'better_errors'
gem 'binding_of_caller'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
