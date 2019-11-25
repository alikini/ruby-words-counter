# frozen_string_literal: true
require 'otr-activerecord'
require 'yaml'


module WordsCounter

  class Storage

    class << self
      def init
        databases_details = YAML.safe_load(File.open('./config/database.yml')).symbolize_keys
        connection_details = databases_details[:development]
        OTR::ActiveRecord.configure_from_hash! connection_details

        puts 'init'

        (0..63).each { |x|
          table_name = "words_#{x}"
          break if ActiveRecord::Base.connection.table_exists?(table_name)
          ActiveRecord::Schema.define do
            create_table table_name do |t|
              t.string(:word, index: true, limit: 200)
              t.integer(:counter)
            end
          end
        }
      end
    end

  end

end






