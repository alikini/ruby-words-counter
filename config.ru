require 'bundler/setup'
require_relative 'main'
require_relative 'lib/storage'
require_relative './extent_file'


WordsCounter::Storage.init()
run Sinatra::Application