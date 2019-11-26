
require_relative 'lib/controller'
require_relative 'lib/storage'

class File
  def each_chunk(chunk_size = 10000000)
    yield read(chunk_size) until eof?
  end
end

WordsCounter::Storage.init()
# processor = WordsCounter::RemoteFileProcessor.new('https://www.w3.org/TR/PNG/iso_8859-1.txt')
# processor.process
#
#

processor = WordsCounter::LocalFileProcessor.new('./sample_data/data.txt')
processor.process


# res =  processor.retrieveStats('why111')
# if res.first.nil?
#   puts 'no res'
# else
#   puts "Counter = #{res.first.appearances}"
# end


