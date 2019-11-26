
# frozen_string_literal: true
require_relative '../extent_file'
require_relative '../lib/storage'


RSpec.configure do |config|

  config.before(:suite) do
    WordsCounter::Storage.init()
  end

end