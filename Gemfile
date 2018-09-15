source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
gem 'bundler', '1.16.1'

# Core'
gem 'devise'
gem 'mysql2', '< 0.5.0'
gem 'state_machine', git: 'https://github.com/shopperplus/state_machine.git'
gem 'public_activity', '1.6.1'
gem 'sentient_user'#, git: 'https://github.com/julioalucero/sentient_user.git'
gem 'wicked'
gem 'carrierwave'
gem 'mini_magick'
gem 'cocoon', '1.2.8', git: 'https://github.com/brenoperucchi/cocoon.git'
gem 'x-editable-rails', git: 'https://github.com/brenoperucchi/x-editable-rails.git'
gem 'unicorn'
gem "responders"
gem "delocalize"
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'filesize'
gem 'acts_as_list'


# Development and Test
group :development, :test do
  # gem 'pg'
  gem 'spring-commands-rspec'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem "factory_bot_rails"
  gem "database_cleaner"
  gem "capybara", "3.4.1"
  gem 'capybara-webkit', '1.15.0'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'rb-fsevent'
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  gem 'byebug', platform: :mri
  gem 'rubocop'
  gem 'rubocop-rspec'
  # gem 'byebug', '9.0.5'

end

group :development do
# gem 'awesome_print'
# gem 'quiet_assets', git: 'https://github.com/fishpercolator/quiet_assets.git'
  gem 'sqlite3'
  gem 'mailcatcher', '0.2.4'
  gem 'better_errors'
  gem 'binding_of_caller'
#   gem 'meta_request'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
  gem 'capistrano-yarn'

end

# Stylesheet
gem 'simple_form', '4.0.1'
gem "slim"
gem "slim-rails"
gem 'bootstrap-sass', '~> 3.3.1'
gem 'bootstrap-sass-extras', '~> 0.0.7'
gem 'sprockets-rails'
# gem 'pages-rails','3.0.0',:git => 'https://github.com/revoxltd/pages-rails.git'

# System
gem 'puma', '~> 3.0'
gem 'sass-rails'#, '~> 5.0'
gem 'uglifier'#, '>= 1.3.0'
gem 'coffee-rails'#, '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console', '>= 3.3.0'
  # gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]