# frozen_string_literal: true
require_relative 'model'
require 'active_record'
require 'net/http'

module WordsCounter
  class Controller

    def initialize(processor)
      @processor = processor
    end

    def process_income_data
      @processor.process
    end

    def retrieve_stats(word)
      word = word.downcase.force_encoding("UTF-8")
      query_result = Words.init(Partitioner.calc(word))
          .where(word: word)
          .group(:word)
          .select('sum(counter) as appearances')
          .order(:word)
      if query_result.first.nil?
        0
      else
        query_result.first.appearances
      end
    end

  end

  class LocalFileProcessor
    def initialize(file_path)
      unless File.file?(file_path)
        puts "File not exists with path: #{file_path}"
        raise 'File not exists'
      end
      @file_path = file_path
    end

    def process
      open(@file_path, "rb") do |f|
        f.each_chunk { |chunk|
          model = ModelRepository.new(chunk)
          model.createBulk
          model.persist
        }
      end
    end
  end

  class RemoteFileProcessor
    def initialize(url)
      @url = url
    end

    def process
      uri = URI(@url)
      Net::HTTP.start(uri.host, uri.port,:use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri

        http.request request do |response|
            response.read_body do |chunk|
              model = ModelRepository.new(chunk)
              model.createBulk
              model.persist
            end
          # end
        end
      end
    end
  end
end


