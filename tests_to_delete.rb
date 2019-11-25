
require_relative 'lib/controller'
require_relative 'lib/storage'


WordsCounter::Storage.init()
processor = WordsCounter::RemoteFileProcessor.new('https://www.w3.org/TR/PNG/iso_8859-1.txt')
processor.process


# res =  processor.retrieveStats('why111')
# if res.first.nil?
#   puts 'no res'
# else
#   puts "Counter = #{res.first.appearances}"
# end


