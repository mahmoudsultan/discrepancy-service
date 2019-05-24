# frozen_string_literal: true

source 'https://rubygems.org'

gem 'activerecord'
gem 'standalone_migrations'

gem 'mysql2', '>= 0.4.4', '< 0.6.0'

group :development do
  gem 'rubocop', require: false
end

group :test do
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'rspec'
end
