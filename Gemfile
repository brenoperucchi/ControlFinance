source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.2'

# Core'
gem 'devise'
gem 'mysql2'
gem 'state_machine', git: 'https://github.com/shopperplus/state_machine.git'
gem 'public_activity'
gem 'sentient_user'#, git: 'https://github.com/julioalucero/sentient_user.git'
gem 'wicked'
gem 'carrierwave'
gem 'mini_magick'
gem 'cocoon', '1.2.8', git: 'https://github.com/bperucchi/cocoon.git'
gem 'x-editable-rails'
gem 'unicorn'


# Development and Test
group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'factory_girl_rails'
  gem "database_cleaner"
  gem "capybara", "2.7.1"
  gem 'capybara-webkit', '1.10.0'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'rb-fsevent'
end

group :development do
#   gem 'awesome_print'
  # gem 'quiet_assets', git: 'https://github.com/fishpercolator/quiet_assets.git'
  gem 'mailcatcher'
  gem 'better_errors'
  gem 'binding_of_caller'
#   gem 'meta_request'
end

# Stylesheet
gem 'simple_form', '~> 3.5.0'
gem "slim"
gem "slim-rails"
gem 'bootstrap-sass', '~> 3.3.1'
gem 'bootstrap-sass-extras', '~> 0.0.7'
gem 'sprockets-rails', '2.3.3'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry'
  gem 'pry-nav'
  # gem 'byebug', '9.0.5'
  gem 'pry-stack_explorer'

  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  # gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
