require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack/contrib'
require_relative 'lib/storage'
require_relative 'lib/controller'
require 'securerandom'

use Rack::PostBodyContentTypeParser
set :show_exceptions, false


get '/stats' do
  word = params[:word]
  if word.to_s == ''
    halt 400
    return
  end

  controller = WordsCounter::Controller.new(nil)
  res = controller.retrieve_stats(word.to_s)
  status 200
  res.to_s
end

post '/process' do
  body = request.body.read
  local_file = params[:file_path]
  url = params[:url]

  puts local_file.to_s
  if body.to_s == '' && local_file.to_s == '' && url.to_s == ''
    halt 400
    return
  end

  if local_file.to_s != ''
    local_file_processor = WordsCounter::LocalFileProcessor.new(local_file.to_s)
    controller = WordsCounter::Controller.new(local_file_processor)
  elsif url.to_s != ''
    remote_file_processor = WordsCounter::RemoteFileProcessor.new(url.to_s)
    controller = WordsCounter::Controller.new(remote_file_processor)
  elsif body.to_s != ''
    file = "./tmp/#{SecureRandom.uuid}.txt"
    open(file, "w") do |f|
      f.write body
    end

    local_file_processor = WordsCounter::LocalFileProcessor.new(file)
    controller = WordsCounter::Controller.new(local_file_processor)

  end

  controller.process_income_data
# child_pid = fork do
#   controller.process_income_data
#   exit
# end
#
# Process.detach child_pid

  body("Done")
rescue StandardError => e
  puts e.message
  halt 400
end
