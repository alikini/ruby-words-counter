# frozen_string_literal: true
require('active_record')
require('bulk_insert')
require('xxhash')

module WordsCounter


  class Words < ActiveRecord::Base
    def self.init(partition)
      self.table_name = "words_#{partition}"
      self
    end
  end

  class WordCount < ActiveRecord::Base
    def self.init(partition)
      self.table_name = "words_#{partition}"
    end
  end

  class ModelRepository

    def initialize(text)
      @text = text
      # 64 is a magic number that should be extracted to a single const
      @hashed_data = Array.new(64)
    end

    def create_bulk
      @text.scan(/[^\s\d]+/).each do |word|
        word = word.downcase.force_encoding("UTF-8")
        partition = Partitioner.calc(word)

        hash = @hashed_data[partition]
        unless hash
          hash = {}
          @hashed_data[partition] = hash
        end

        current = hash.fetch(word, 0)
        current += 1
        hash[word] = current
      end
    end


    def persist
      @hashed_data.each_with_index do |data, partition|
        next unless data

        records_list = data.map { | key, value | {:word => key, :counter => value } }

        WordCount.init(partition)
        WordCount.bulk_insert set_size: 100000 do |worker|
          records_list.each do |attrs|
            worker.add(attrs)
          end
        end
      end
    end

  end

  class Partitioner

    class << self
      def calc(word)
        seed = 12345
        XXhash.xxh32(word, seed) % 64
      end
    end

  end


end


