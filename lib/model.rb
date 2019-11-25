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
      @hashed_data = Array.new(64)
    end

    def createBulk
      @text.scan(/[^\s\d]+/).each do |word|
        word = word.downcase.force_encoding("UTF-8")
        partition = Partitioner.calc(word)
        @hashed_data[partition] = Hash.new if @hashed_data[partition] == nil

        current = @hashed_data[partition][word]
        if current == nil
          @hashed_data[partition][word] = 1
        else
          @hashed_data[partition][word] = current + 1
        end
      end
    end


    def persist
      partition = 0
      @hashed_data.each do |data|
        if data == nil
          partition = partition + 1
          next
        end

        records_list = Array.new(data.keys.size)
        location = 0
        data.keys.each do |key|
          records_list[location] = {:word => key, :counter => data[key]}
          location = location  + 1
        end
        WordCount.init(partition)
        WordCount.bulk_insert do |worker|
          records_list.each do |attrs|
            worker.add(attrs)
          end
        end
        partition = partition + 1
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


