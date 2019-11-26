source 'https://rubygems.org'

ruby('~> 2.6')

gem "sinatra"
gem 'rack-contrib'
gem 'sinatra-contrib'
gem 'mysql2'
gem 'activerecord'
gem 'otr-activerecord'
gem 'puma'
gem 'bulk_insert'
gem 'xxhash'

group :development, :test do
  gem 'annotate', require: false
  gem 'brakeman'
  gem 'byebug', platforms: %i(mri mingw x64_mingw)
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-byebug'
  gem 'rspec', '~> 3.7.0'
end