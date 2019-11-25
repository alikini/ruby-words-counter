require 'bundler/setup'
require_relative 'main'
require_relative 'lib/storage'

class File
  def each_chunk(chunk_size = 1024)
    yield read(chunk_size) until eof?
  end
end

WordsCounter::Storage.init()
run Sinatra::Application