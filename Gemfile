# encoding: UTF-8
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

gem "rails",  "~> 5.2.0"
gem "mysql2", ">= 0.4.4", "< 0.6.0"
gem "puma",   "~> 3.11.4"

group :development, :test do
  gem "pry-byebug", "~> 3.6"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
end

group :test do
  gem "rspec-rails",      "~> 3.7"
  gem "database_cleaner", "~> 1.7"
  gem "mocha",            "~> 1.4", require: false
end
